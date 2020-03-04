/*
 * Filename: mk_buildlevel.cmd
 *   Author: JAN-ERIK
 *  Created: Sun Aug 17 2014
 *  Purpose: 
 *  Changes: 
 */

/*
 @#<Vendor>:<Revision>#@##1## DD.MM.YY hh:mm:ss      <BuildHost>:<ASDFeatureID>:<LanguageCode>:<CountryCode>:<Build>:<Unknown>:<FixPackVer>@@<Description>
 */
'@del buildlevel.rc'
build_version = ''
build_cpu = ''
build_fixpak = ''
build_description = ''
build_feature = ''

newln = D2C(13)||D2C(10)
variable_names = 'VER_MAJOR VER_MINOR VER_REVISION VER_BUILD APP_DATE APP_VENDOR APP_EMAIL APP_HOMEPAGE APP_NAME APP_DESCRIPTION'
variable_values = 'build_major build_minor build_revision build_build build_date build_vendor build_email build_homepage build_name build_description'

IF ARG() > 0 THEN
DO
   IF STREAM( ARG(1), 'C', 'QUERY EXISTS' ) <> '' THEN
   DO
      f_size = STREAM( ARG(1), 'C', 'QUERY SIZE' )
      IF f_size > 10 THEN
      DO
         input = CHARIN( ARG(1), 1, f_size )
         DO i = 1 TO WORDS( variable_names )
            variable_name = SUBWORD( variable_names, i, 1 )
            PARSE VALUE input WITH .(vname)input(newln)
            CALL VALUE SUBWORD( variable_values, i, 1 ), STRIP( STRIP( input ),, '"' )
         END
      END
      PARSE VALUE STREAM( ARG(1), 'C', 'QUERY DATETIME' ) WITH mo'-'dd'-'yy' 'hh':'mi':'ss
   END
END
IF \DATATYPE( build_major, 'W' ) THEN
DO i = 1 TO WORDS( variable_names )
   CALL CHAROUT 'STDOUT', SUBWORD( variable_names, i, 1 )': '
   PARSE PULL input
   CALL VALUE SUBWORD( variable_values, i, 1 ), STRIP( input,, '"' )
END
IF DATATYPE( yy, 'W' ) THEN
    build_date = '20'||yy||'-'||mo||'-'||dd||hh||':'||mi
IF SYMBOL( 'build_date' ) <> 'VAR' THEN
DO
    PARSE VALUE DATE( 'O' ) WITH yyyy'/'mm'/'dd
    build_date = yyyy||'-'||mm||'-'||dd
    build_time = ' '||LEFT( TIME('N'), 5 )
END
build_date = ' '||STRIP( build_date )

build_host = VALUE( 'HOSTNAME',, 'OS2ENVIRONMENT' )
build_host = COPIES( ' ', 9 )||LEFT( build_host, MIN( LENGTH( build_host ), 11 ) )
build_language = TRANSLATE( LEFT( VALUE( 'LANG',, 'OS2ENVIRONMENT' ), 2 ) )
build_country = TRANSLATE( RIGHT( VALUE( 'LANG',, 'OS2ENVIRONMENT' ), 2 ) )
build_version = STRIP( build_major,, D2C(9) )||'.'||RIGHT( '0'||STRIP( build_minor,, D2C(9) ), 2 )
IF LENGTH( STRIP( build_revision ) ) > 0 THEN
   build_version = build_version'.'RIGHT( '0'||STRIP( STRIP( build_revision ),, D2C(9) ), 2 )
build_build = STRIP( build_build,, D2C(9) )
IF \DATATYPE( build_build, 'W' ) THEN
    build_build = ''
CALL CHAROUT , "Language specific application? ("||build_language||") (y/N) "
PARSE PULL answer
IF TRANSLATE( LEFT( answer, 1 ) ) = 'Y' THEN
DO
    CALL CHAROUT , "Only for use with Language? ("||build_language||" by default ) "
    PARSE PULL answer
    IF STRIP( answer ) <> '' THEN
        build_language = TRANSLATE( LEFT( answer, 2 ) )
END
ELSE build_language = ''
CALL CHAROUT , "Country specific application? ("||build_country||") (y/N) "
PARSE PULL answer
IF TRANSLATE( LEFT( answer, 1 ) ) = 'Y' THEN
DO
    CALL CHAROUT , "Only for use with Country? ("||build_country||" by default ) "
    PARSE PULL answer
    IF STRIP( answer ) <> '' THEN
        build_country = TRANSLATE( LEFT( answer, 2 ) )
END
    ELSE build_country = ''
CALL CHAROUT , "Require specific fixpak? (y/N)"
PARSE PULL answer
IF TRANSLATE( LEFT( answer, 1 ) ) = 'Y' THEN
DO
    CALL CHAROUT , "State the fixpak number required ( none by default ) "
    PARSE PULL answer
    IF STRIP( answer ) <> '' THEN
        build_fixpak = answer
END
ELSE build_fixpak = ''

CALL LINEOUT 'buildlevel.rc', 'RCDATA 1 { "@#'||build_vendor||':'||build_version||'#@##1##'||build_date||build_host||':'||build_feature||':'||build_language||':'||build_country||':'||build_build||':'||build_cpu||':'||build_fixpak||'@@'||build_description||'" }'
RETURN 0
