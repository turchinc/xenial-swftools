require 'gfx'

class TestRender < GFX::Device
    def startpage(width,height)
        puts "startpage(#{width},#{height})"
    end
    def endpage()
        puts "endpage()"
    end
    def setparameter(key,value)
        puts "setparameter(#{key},#{value})"
    end
    def startclip(line)
        puts "startclip(#{line.inspect})"
    end
    def endclip()
        puts "endclip()"
    end
    def stroke(line, width, color, cap_style, joint_style, miterLimit)
        puts "stroke(#{line.inspect}, #{width}, #{color.inspect}, #{cap_style}, #{joint_style}, #{miterLimit})"
    end
    def fill(line, color)
        puts "fill(#{line.inspect}, #{color.inspect})"
    end
    def fillbitmap(line, img, imgcoord2devcoord, cxform)
        puts "fillbitmap(#{line.inspect}, #{img}, #{imgcoord2devcoord}, #{cxform})"
    end
    def fillgradient(dev, line, gradient, type, gradcoord2devcoord)
        puts "fillgradient(#{line.inspect}, #{gradient}, #{type}, #{gradcoord2devcoord})"
    end
    def addfont(font)
        puts "addfont(#{font.name})"
    end
    def drawchar(font, glyph, color, matrix)
        puts "drawchar(#{font.name}, #{glyph}, #{color.inspect}, #{matrix.inspect})"
    end
    def drawlink(line, action, text)
        puts "drawchar(#{line.inspect}, #{action}, #{text})"
    end
end

pdf = GFX::PDF.new('abcdef.pdf')
r = TestRender.new
pdf.render(r, "1-5", [:remove_font_transforms])

