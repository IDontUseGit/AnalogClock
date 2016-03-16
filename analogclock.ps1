param([int]$locx = 768, [int]$locy = 64, [int]$width = 200, [int]$height = 200)

$centerx = $width / 2
$centery = $height / 2 

$form = new-object system.windows.forms.form
$form.backcolor = [system.drawing.color]::lime;
$form.transparencykey = [system.drawing.color]::lime;
$form.formborderstyle = [System.Windows.Forms.FormBorderStyle]::None
$form.height = $height + $centery 
$form.width = $width + $centerx
$form.StartPosition = [system.windows.forms.formstartposition]::manual
$form.location = new-object system.drawing.point -argumentlist @($locx, $locy)
$bitmap = new-object system.drawing.bitmap -argumentlist @(($width + $centerx), ($height + $centery))
$g = [system.drawing.graphics]::fromimage($bitmap)
$g.translatetransform(3,3)
$g.smoothingmode = [system.drawing.drawing2d.smoothingmode]::none
$timer = new-object system.windows.forms.timer
$pen = new-object system.drawing.pen -argumentlist @([system.drawing.color]::black, 1)
$brush = [system.drawing.brushes]::black
$font = new-object System.Drawing.Font -argumentlist @("Microsoft Sans Serif", 14)

$Render_Back = 
{
    $g.Clear($form.backcolor)
    
    $g.FillEllipse([system.drawing.brushes]::white, $centerx - $width / 2, $centery - $height / 2, $width, $height)
    
    $pen.width = 35
    $pen.color = [system.drawing.color]::fromargb(225, 225, 225) 
    $pen.alignment  = [system.drawing.drawing2d.penalignment]::inset  
    
    $g.DrawEllipse($pen, $centerx - $width / 2, $centery - $height / 2, $width, $height) 
    
    $pen.width = 3
    $pen.color = [system.drawing.color]::fromargb(0, 0, 0) 
    $pen.alignment  = [system.drawing.drawing2d.penalignment]::outset  
    
    $g.DrawEllipse($pen, $centerx - $width / 2, $centery - $height / 2, $width, $height)
    
    $pen.width = 3
    $pen.color = [system.drawing.color]::fromargb(0, 0, 0) 
    $pen.alignment  = [system.drawing.drawing2d.penalignment]::center
    
    #проставл€ем все часы
    for($i=1; $i -le 12; $i++)
    {
        $ang = 2.0 * [system.math]::PI * $i / 12.0
        
        $dx0 = (($width - 10) / 2 * [system.math]::sin($ang)) + $centerx
        $dy0 = (-($height - 10) / 2 * [system.math]::cos($ang)) + $centery
        $dx1 = (($width - 45) / 2 * [system.math]::sin($ang)) + $centerx
        $dy1 = (-($height - 45) / 2 * [system.math]::cos($ang)) + $centery
        $dx2 = (($width - 80) / 2 * [system.math]::sin($ang)) + $centerx
        $dy2 = (-($height - 80) / 2 * [system.math]::cos($ang)) + $centery
        
        $g.DrawLine($pen, $dx1, $dy1, $dx0, $dy0)
        
        $pos = new-object system.drawing.pointf -argumentlist @(($dx2-12), ($dy2-12))
        
        if ($i -le 6)
            {$text=" "}
        else
            {$text=""}
        $text = $text + $i
        
        $g.drawstring($text, $font, $brush, $pos)
    }
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
    
    #часова€ стрелка
    $cx = ((($width - 100) / 2)  * [system.math]::sin($hang)) + $centerx
    $cy = ((-($height - 100) / 2) * [system.math]::cos($hang)) + $centery
    $g.DrawLine($pen, $centerx, $centery, $cx, $cy)
    
    $pen.width = 5
    $pen.color = [system.drawing.color]::fromargb(64, 64, 64) 
    
    #минутна€ стрелка
    $cx = ((($width - 50) / 2)  * [system.math]::sin($mang)) + $centerx
    $cy = ((-($height - 50) / 2) * [system.math]::cos($mang)) + $centery
    $g.DrawLine($pen, $centerx, $centery, $cx, $cy)
    
    $pen.width = 3
    $pen.color = [system.drawing.color]::red
    
    #секундна€ стрелка
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

$Show_DigiTime = 
{
    $form.text = "—истемное врем€ " + [system.datetime]::now.hour + ":" + [system.datetime]::now.minute + ":" + [system.datetime]::now.second 
}

$Render = 
{
    &$Render_Back
    &$Render_Face
    &$Render_Screen
    &$Show_DigiTime
}

$timer.enabled = $true
$timer.interval = 45
$timer.add_tick($Render)

$form.ShowDialog()

$timer.enabled = $false
$timer.dispose()
$form.dispose()
