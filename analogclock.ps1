$width = 300
$height = 300
$centerx = 150
$centery = 150

$form = new-object system.windows.forms.form
$form.height = 512
$form.width = 512
$g = $form.CreateGraphics()
$g.translatetransform(50, 50)
$timer = new-object system.windows.forms.timer
$pen = [system.drawing.pens]::black
$brush = [system.drawing.brushes]::black
$font = new-object System.Drawing.Font -argumentlist @("Microsoft Sans Serif", 14)

$Render_Back = 
{
    $g.Clear($form.backcolor)
    $g.DrawEllipse($pen, 0, 0, $width, $height) 
    
    $dx = $width / 2 - 15
    $dy = 0 
    $pos = new-object system.drawing.pointf -argumentlist @($dx, $dy)
    $text = "12"
    $g.drawstring($text, $font, $brush, $pos)
    
    $dx = $width - 15
    $dy = $height / 2 - 15 
    $pos = new-object system.drawing.pointf -argumentlist @($dx, $dy)
    $text = "3"
    $g.drawstring($text, $font, $brush, $pos)
    
    $dx = $width / 2 - 15
    $dy = $height - 25
    $pos = new-object system.drawing.pointf -argumentlist @($dx, $dy)
    $text = "6"
    $g.drawstring($text, $font, $brush, $pos)
    
    $dx = 0 
    $dy = $height / 2 - 15
    $pos = new-object system.drawing.pointf -argumentlist @($dx, $dy)
    $text = "9"
    $g.drawstring($text, $font, $brush, $pos)   
}

$Render_Face =
{
    $h = [system.datetime]::now.hour
    $m = [system.datetime]::now.minute
    $s = [system.datetime]::now.second

    $sang = 2.0 * [system.math]::PI * $s / 60.0
    $mang = 2.0 * [system.math]::PI * ($m + $s / 60.0) / 60.0
    $hang = 2.0 * [system.math]::PI * ($h + $m / 60.0) / 12.0
    
    #������� �������
    $cx = ((($width - 100) / 2)  * [system.math]::sin($hang)) + $centerx
    $cy = ((-($height - 100) / 2) * [system.math]::cos($hang)) + $centery
    $g.DrawLine($pen, $centerx, $centery, $cx, $cy)
    
    #�������� �������
    $cx = ((($width - 50) / 2)  * [system.math]::sin($mang)) + $centerx
    $cy = ((-($height - 50) / 2) * [system.math]::cos($mang)) + $centery
    $g.DrawLine($pen, $centerx, $centery, $cx, $cy)
    
    #��������� �������
    $cx = ((($width - 15) / 2)  * [system.math]::sin($sang)) + $centerx
    $cy = ((-($height - 15) / 2) * [system.math]::cos($sang)) + $centery
    $g.DrawLine($pen, $centerx, $centery, $cx, $cy)
}

$Render = 
{
    &$Render_Back
    &$Render_Face
}

$timer.enabled = $true
$timer.interval = 45
$timer.add_tick($Render)

#$form.controls.add($timer)
$form.ShowDialog()

$timer.enabled = $false
$timer.dispose()
$form.dispose()
