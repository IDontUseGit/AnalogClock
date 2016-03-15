$width = 300
$height = 300
$centerx = 150
$centery = 150

$form = new-object system.windows.forms.form
$form.height = 512
$form.width = 512
$bitmap = new-object system.drawing.bitmap -argumentlist @(512, 512)
#$g = $form.CreateGraphics()
$g = [system.drawing.graphics]::fromimage($bitmap)
$g.translatetransform(50, 50)
$timer = new-object system.windows.forms.timer
$pen = new-object system.drawing.pen -argumentlist @([system.drawing.color]::black, 1)
$brush = [system.drawing.brushes]::black
$font = new-object System.Drawing.Font -argumentlist @("Microsoft Sans Serif", 14)

$Render_Back = 
{
    $g.Clear($form.backcolor)
    
    $pen.width = 30
    $pen.color = [system.drawing.color]::fromargb(200, 200, 200) 
    $pen.alignment  = [system.drawing.drawing2d.penalignment]::inset  
    
    $g.DrawEllipse($pen, 0, 0, $width, $height) 
    
    $pen.width = 1
    $pen.color = [system.drawing.color]::fromargb(0, 0, 0) 
    $pen.alignment  = [system.drawing.drawing2d.penalignment]::center
    
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
    
    $pen.width = 10
    $pen.color = [system.drawing.color]::fromargb(64, 64, 64) 
    $pen.alignment  = [system.drawing.drawing2d.penalignment]::center
    
    #часовая стрелка
    $cx = ((($width - 100) / 2)  * [system.math]::sin($hang)) + $centerx
    $cy = ((-($height - 100) / 2) * [system.math]::cos($hang)) + $centery
    $g.DrawLine($pen, $centerx, $centery, $cx, $cy)
    
    $pen.width = 5
    $pen.color = [system.drawing.color]::fromargb(64, 64, 64) 
    
    #минутная стрелка
    $cx = ((($width - 50) / 2)  * [system.math]::sin($mang)) + $centerx
    $cy = ((-($height - 50) / 2) * [system.math]::cos($mang)) + $centery
    $g.DrawLine($pen, $centerx, $centery, $cx, $cy)
    
    $pen.width = 3
    $pen.color = [system.drawing.color]::red
    
    #секундная стрелка
    $cx = ((($width - 15) / 2)  * [system.math]::sin($sang)) + $centerx
    $cy = ((-($height - 15) / 2) * [system.math]::cos($sang)) + $centery
    $g.DrawLine($pen, $centerx, $centery, $cx, $cy)
    
    #гвоздик
    $g.FillEllipse($brush, 0 + $centerx - 7, 0 + $centery - 7, 15, 15)
    
    $pen.width = 1
    $pen.color = [system.drawing.color]::black
}

$Render_Screen = 
{
    $fgraph = $form.CreateGraphics()
    $fgraph.DrawImage($bitmap, 0, 0)
}

$Render = 
{
    &$Render_Back
    &$Render_Face
    &$Render_Screen
}

$timer.enabled = $true
$timer.interval = 45
$timer.add_tick($Render)

#$form.controls.add($timer)
$form.ShowDialog()

$timer.enabled = $false
$timer.dispose()
$form.dispose()
