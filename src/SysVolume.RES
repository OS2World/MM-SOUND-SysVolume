� �� 0O   d   mainm   l   k   j   i   e   h   f   g   �  tooltip�  � lbl��� 0)  SetMute�Mute= \Mute
CALL SetVolume (1 <> Mute ) * master
switched = 'Mute'
IF Mute = 1 THEN
DO
  CALL main.C107.Text '#112'
  switched = 'Muted'
END
ELSE
   CALL main.C107.Text '#111'
CALL C101.Hide
DO i = 2 To 8
   CALL TopFor 'main', 'C10'||i
   IF Mute = 1 & i < 7 THEN
      CALL DisableFor 'main', 'C10'||i
  ELSE IF Compact = 1 & i < 7 | Compact = 0 THEN
     CALL EnableFor 'main', 'C10'||i
END
DO i = 2 TO 3
  CALL TextFor 'main', 'C10'||i, '#1'||( 2 - Compact )||( 2 * i - 1 + Mute )
END
CALL TopFor 'main', 'C103'
CALL TopFor 'main', 'C107'
CALL C101.Show
CALL C107.Show
CALL C104.Text master'%'
refreshed = 1
isBusy= 0	SetVolume^PROCEDURE EXPOSE err
  err = mciRxSendString( 'masteraudio volume '||ARG(1), 'retval', 0, 0 )ReSize�IF isBusy = 0 THEN
DO
PARSE VALUE main.Position() WITH x y w h
PARSE VALUE main.Frame() WITH l b r t
PARSE VALUE main.C104.Font() WITH fonsze'.'.
IF Compact = 1 THEN
DO
mode = 'Switch from compact mode'
dw = max( ( w - l - r - 32 ), l + r + 48 ) % 1
dh = 16
CALL main.Position x, y, dw + l + r + 32, dh + t + b
CALL main.C101.Position l + 16, b, dw, dh
CALL main.C102.Text '#11'||( 3 + Mute )
CALL main.C102.Position l + 16, b, dw, dh
CALL main.C102.Style D2C( 41943186 )
CALL main.C103.Text '#11'||( 5 + Mute )
CALL main.C103.Position l + 14 + ( dw * master / 100 ) % 1, b, 7, 16
CALL main.C104.Position l, 0, 0, 0
CALL main.C105.Position l, b, 16, dh
CALL main.C105.Hide
CALL main.C106.Position w - r - 16, b, 16, dh
CALL main.C106.Hide
CALL main.C107.Position l, b, 16, dh
CALL main.C108.Text '#118'
CALL main.C108.Position w - r - 16, b, 16, dh
END
ELSE DO
mode = 'Switch to compact mode'
IF 16 < h - t - b THEN
DO
   dw = min( ( w - l - r ), ( h - t - b ) * 672 / 434 ) % 1
   dh = min( ( w - l - r ) * 434 / 672, ( h - t - b ) ) % 1
END
ELSE DO
   dw = w - l - r
   dh = ( dw * 434 / 672 ) % 1
END
lw = ( ( 1 + LENGTH( master ) ) * fonsze ) % 1
MVL.cx = 1 + ( dw  * ( 308 - 160 * cos( VAL( 'pi' ) * 2 * ( master - 5 ) / 180 ) ) / 672 ) % 1
MVL.cw = ( dw / 13 ) % 1
MVL.cy = ( dh * ( 308 - 100 * sin( VAL( 'pi' ) * 2 * ( master - 5 ) / 180 )  ) / 434 ) % 1
MVL.ch = ( dh / 14.5 ) % 1

ly = ( dh * 308 / 434 - fonsze / 2 + 2 ) % 1
CALL main.Position x, y, w, dh + t + b
CALL main.C101.Position l, b, dw, dh
CALL main.C102.Text '#12'||( 3 + Mute )
CALL main.C102.Position l, b, dw, dh
CALL main.C102.Style D2C( 25165970 )
CALL main.C103.Text '#12'||( 5 + Mute )
CALL main.C103.Position l + MVL.cx, b + MVL.cy, MVL.cw, MVL.ch
CALL main.C104.Position l + ( dw - lw ) / 2 % 1, ly, lw, fonsze + 4
CALL main.C105.Position l, b, 16, 16
CALL main.C105.Show
CALL main.C106.Position w - r - 16, b, 16, 16
CALL main.C106.Show
CALL main.C107.Position l, h - t - 16, 16, 16
CALL main.C108.Text '#117'
CALL main.C108.Position w - r - 16, h - t - 16, 16, 16
END
CALL Notify 'main', 'Redraw'
END
CALL SysIni 'USER', 'SysVolume', 'Position', main.Position()ilog�PROCEDURE
PARSE ARG x, y, bot, top
NUMERIC DIGITS VAL( 'precision' )
 
high = y > top
signed = 1 - 2 * ( high <> ( x > 1 ) )
 
i = 0
DO WHILE high & y > top | \high & y < bot
   f = x
   DO j = -1
      q = y * f ** -signed
      IF j >= 0 & ( high & q < top | \high & q > bot ) THEN LEAVE
      f = f * f
      g = q
   END

   y = g
   i = i + signed * 2 ** j
END

RETURN i
sqrt�PROCEDURE
NUMERIC DIGITS VAL( 'precision' )
x = ARG(1)
IF x = 0 THEN RETURN 0
IF x = 1 THEN RETURN 1

/* Adjust number so it is between 1 and 100. */
i = ILog( 100, x, 1, 100 )
x = x * 100 ** -i

y = x / 2
old = y
DO n = 1
  y = ( ( x / y ) + y ) / 2
  IF y = old THEN LEAVE
  old = y
END

RETURN y * 10 ** iarccosWPROCEDURE
NUMERIC DIGITS VAL( 'precision' )
RETURN VAL( 'pi' ) / 2 - ArcSin( ARG(1) )arcsin�PROCEDURE
NUMERIC DIGITS VAL( 'precision' )
x = ARG(1)

IF 1 < ABS( x ) THEN
   SIGNAL RETURN

/* Avoid region where series converges slowly.  (Note recursion!) */
IF .75 <= ABS( x ) THEN
  RETURN SIGN( x ) * ArcCos( Sqrt( 1 - x ** 2 ) )

f = x
y = x
x = x ** 2
old = y
DO n = 2 BY 2
   f = f * x * ( n - 1 ) / n
   y = y + f / ( n + 1 )
   IF y = old THEN LEAVE
   old = y
END

RETURN ycos�PROCEDURE
NUMERIC DIGITS VAL( 'precision' )
x = ARG(1)

IF 10 ** ( digits() % 4 ) <= ABS( x ) THEN
   SIGNAL RETURN

x = x // ( 2 * VAL( 'pi' ) ) /* Adjust between pi and -pi, for convergence. */
IF VAL( 'pi' ) < ABS( x ) THEN x = x - SIGN( x ) * 2 * ABS( VAL( 'pi' ) )
 
f = 1
y = 1
x = x ** 2
old = y
DO n = 2 By 2
  f = -f * x / ( n * ( n - 1 ) )
  y = y + f
  IF y = old THEN LEAVE
  old = y
END
 
RETURN ysin�PROCEDURE
NUMERIC DIGITS VAL( 'precision' )
x = ARG(1)

IF 10 ** ( digits() % 4 ) <= ABS( x ) THEN
   SIGNAL RETURN

x = x // ( 2 * VAL( 'pi' ) ) /* Adjust between pi and -pi, for convergence. */
IF VAL( 'pi' ) < ABS( x ) THEN x = x - SIGN( x ) * 2 * ABS( VAL( 'pi' ) )
 
f = x
y = x
x = x ** 2
old = y
DO n = 2 By 2
  f = -f * x / ( n * ( n + 1 ) )
  y = y + f
  IF y = old THEN LEAVE
  old = y
END
 
RETURN yLoadLib�   SIGNAL ON SYNTAX NAME RxNoLib
   CALL RxFuncAdd ARG(1), ARG(2), ARG(1)
   IF ARG() < 3 THEN
      INTERPRET 'CALL '||ARG(1)
   SIGNAL OFF SYNTAX
RETURN RxFuncQuery( ARG(1) )	GetVolumeoPROCEDURE EXPOSE err
  err = mciRxSendString( 'masteraudio query volume wait', 'retval', 0, 0 )
return retval�� �d 0�  �  �  ��    	      :  # ) @  d ��A        E       m M��    
 x �   � ��  l ���    
 � �   � ��  k ���        � �    j ���        7 �    i 9��     |  �   �    e ���        � �    h ���    	 � � �    f 	��    	 L V� �    g [��Volume #   Default '         9.WarpSans                     ICONBUTTON #117 *      "   9.WarpSans                        ICONBUTTON #111 (          9.WarpSans                      + ?      7   9.WarpSans                                             - ?      7   9.WarpSans                                             TURTLE  ?      7   9.WarpSans                                             Text *      "   9.WarpSans                        BILLBOARD #123 ?      7   9.WarpSans                                             BILLBOARD #125 ?      7   9.WarpSans                                             ���d 0D	  �d GetFocusCall ReSizeKey�CALL EventData
IF EventData.1 = '+' | EventData.1 = 'RIGHT'  THEN
DO
   master = MIN( master + 5, 100 )
  CALL ReSize
END
ELSE IF EventData.1 = '-' | EventData.1 = 'LEFT' THEN
DO
   master = MAX( master - 5, 0 )
  CALL ReSize
END
ELSE IF EventData.1 = 'BACKSPACE' | EventData.1 = 'DELETE' THEN
   CALL SetMute
ELSE IF EventData.1 = '_' THEN
DO
  Compact = \Compact
  CALL ReSize
END
ELSE IF EventData.1 = 'F1' THEN
   '@view SysVolume'
CALL C109.Select 1Notify�CALL C101.Hide
DO i = 2 To 8
   CALL TopFor 'main', 'C10'||i
END
CALL TopFor 'main', 'C103'
CALL C101.Show
CALL C104.Text master'%'
IF Mute = 0 THEN
  CALL SetVolume master
refreshed = 1
isBusy= 0Open�Compact = SysIni( 'USER', 'SysVolume', 'Mode' )
IF \DATATYPE( Compact, 'B' ) THEN
  Compact = 0
CALL VAL 'MasterWin', SysIni( 'USER', 'SysVolume', 'Position' )
IF VAL( 'MasterWin' ) <> '' THEN
  IF DATATYPE( SPACE( VAL( 'MasterWin' ), 0 ), 'N' ) THEN
  DO
    PARSE VALUE VAL( 'MasterWin' ) WITH x y w h
    CALL main.Position x, y, w, h
  END
CALL ReSizeTimerCALL main.Timer
CALL ReSizeSize$CALL main.Timer
CALL main.Timer 500Init�isBusy = 0
CALL VAL 'precision', 17
CALL VAL 'pi', 3.14159265358979323846264338327950288419716939937511
IF LoadLib( 'mciRxInit', 'MCIAPI' ) <> 0 THEN RETURN 1
IF LoadLib( 'SysLoadFuncs', 'RexxUtil' ) <> 0 THEN RETURN 2
Mute = 0
switched = 'Mute'
mode = 'Switch to compact mode'
master = GetVolume()
CALL tooltip.Open
CALL main.Show
PARSE SOURCE WITH . . this
PARSE VALUE REVERSE( this ) WITH .'\'this
CALL DIRECTORY REVERSE( this )�e 	MouseMove�IF move = 1 & refreshed = 1 THEN
DO
   refreshed = 0
   CALL EventData 'ev.'
   CALL main.Timer
   IF Compact = 1 Then
      master = 100 * ev.1 / dw % 1
   ELSE IF ev.2 < dh * ( 308 - 100 * sin( VAL( 'pi' ) * 2 * ( master - 5 ) / 180 )  ) / 434 THEN
      master = ( 100 * min( dw - 200 * dw / 672, max( ( ev.1 - 100 * dw / 672 ), 0 ) ) / ( dw - 200 * dw / 672 ) ) % 1
   CALL main.Timer 500
ENDButton1Downmove = 1	Button1Upmove = 0�i ClickMIF 0 < master THEN
DO
   master = max( master - 5, 0 )
   CALL ReSize
END�j ClickQIF master < 100 THEN
DO
   master = min( master + 5, 100 )
   CALL ReSize
END�k ClickCALL SetMute�l ClickQCompact = \Compact
CALL SysIni 'USER', 'SysVolume', 'Mode', Compact
CALL ReSize����d 0�    g main;C103;FORMAT(master,,2)||'%''h main;C104;FORMAT(master,,0)||'% volume'*e main;C103;FORMAT( master,, 0 )||'% volume'i main;C105;'Decrease volume 5%'j main;C106;'Increase volume 5%'k main;C107;VALUE( 'switched' )l main;C108;VALUE( 'mode' )�� ��0�   �   �  ��           h    1   ���i         m       	  �s �         �  �     �� ��     Entry          9.WarpSans        Text          9.WarpSans  ����0	  ��Timer�CALL tooltip.Timer
IF tooltip.Visible() THEN
   CALL tooltip.Hide
ELSE DO
   CALL tooltip.Show
   CALL tooltip.Top
   CALL tooltip.Timer 3000
END��IniteCALL Font '10.Helv'
CALL Font '9.WarpSans'
CALL Color '+', '#0 0 0'
CALL Color '-', '#255 255 190'��Changed�PARSE VALUE Text() WITH dlg';'ctrl';'ttl
IF 0 < LENGTH( ctrl ) THEN
DO
   CALL tooltip.Timer
   PARSE VALUE PositionFor( dlg ) WITH x y w h
   PARSE VALUE PositionFor( dlg, ctrl ) WITH tx ty tw th
   INTERPRET 'txt = '||ttl
   CALL tooltip.Position x + tx + tw % 2 + 20, y + ty - 20, LENGTH( txt ) * 7 + 4, 18
   CALL lbl.Position 1, 1, LENGTH( txt ) * 7 + 2, 16
   CALL lbl.Text txt
   CALL tooltip.Timer 1000
END Init:CALL isDefault 'O'
CALL isDefault 'D'
CALL isDefault 'C'���� 0�   rxVersion:
RETURN '     @#Jan-Erik Laerka:1.00.01#@##1## 22 February, 2020        AMD2300MHZ::::1::@@Control System Master Audio Volume'