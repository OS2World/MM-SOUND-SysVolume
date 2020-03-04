/*
 * Filename: install.cmd
 *   Author: JanErik
 *  Created: Sat Feb 22 2020
 *  Purpose: Create Desktop Objects for System Master Audio Volume
 *  Changes: 
 */

/* Load RexxUtil Library */
If RxFuncQuery('SysLoadFuncs') Then
Do
   Call RxFuncAdd 'SysLoadFuncs', 'RexxUtil', 'SysLoadFuncs'
   Call SysLoadFuncs
End

Obj.1.ID =    '<MMPM2_FOLDER>'

Obj.2.ID =    '<MMOS2_VOLUME>'
Obj.2.Title = 'System Master Volume'
Obj.2.Setup = 'EXENAME='||DIRECTORY()||'\SYSVOLUME.EXE;'
Obj.2.Type =  'WPProgram'
Obj.2.ref =   1

Obj.3.ID =    '<MMOS2_VOLUME_HLP>'
Obj.3.Title = 'System Master Volume Help'
Obj.3.Setup = 'EXENAME=VIEW.EXE;PARAMETERS='||DIRECTORY()||'\SysVolume.inf;'
Obj.3.Type =  'WPProgram'
Obj.3.ref =   1

Obj.0 = 3

DO i = 2 TO Obj.0
   tgt = Obj.i.ref
   tempRC = SysCreateObject( Obj.i.Type,,
   Obj.i.Title,,
   Obj.tgt.ID,,
   'OBJECTID='||Obj.i.ID||';'||Obj.i.Setup,,
   'Update' )
END