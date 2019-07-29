local ffi = require('ffi')
local A3Shape = ffi.load("A3Shape")
ffi.cdef[[
	void free (void* ptr);
	char *shape_ellipse(double x,double y,double w,double h);
	char *shape_rect(double x,double y,double w,double h);
	char *shape_rounded_rect(double x,double y,double w,double h,double rx,double ry);
	
	double shape_angle_at_percent(const char *ass,double t);
	double shape_length(const char *ass);
	double shape_percent_at_length(const char *ass,double len);
	void shape_point_at_percent(const char *ass,double t,double *x,double *y);
	double shape_slope_at_percent(const char *ass,double t);
	void shape_bouding(const char *ass,double *x,double *y,double *w,double *h);
	bool shape_contains_point(const char *ass,double x,double y);
	bool shape_contains_rect(const char *ass,double x,double y,double w,double h);
	char *shape_translate(const char *ass,double dx,double dy);
	char *shape_rotate(const char *ass,double degree);
	char *shape_scale(const char *ass,double sx,double sy);
	char *shape_shear(const char *ass,double sh,double sv);
	
	char *shape_united(const char *ass1,const char *ass2);
	char *shape_intersected(const char *ass1,const char *ass2);
	char *shape_subtracted(const char *ass1,const char *ass2);
	char *shape_outline(const char *ass,double width,const char *cap_style,const char *join_style);
	char *shape_pattern_outline(const char *ass,double width,const char *cap_style,const char *join_style,double pattern_len,double space_len,double dash_offset);
]]


local shape = {}

-- (x,y) the top-left corner of bound rectangle,w for width,h for height
function shape.ellipse(x,y,w,h)
	assert(type(x) == "number", "x is not a number")
	assert(type(y) == "number", "y is not a number")
	assert(type(w) == "number", "w is not a number")
	assert(type(h) == "number", "h is not a number")
	local ps = A3Shape.shape_ellipse(x,y,w,h)
	local s = ffi.string(ps)
	ffi.C.free(ps)
	return s
end


function shape.rect(x,y,w,h)
	assert(type(x) == "number", "x is not a number")
	assert(type(y) == "number", "y is not a number")
	assert(type(w) == "number", "w is not a number")
	assert(type(h) == "number", "h is not a number")
	local ps = A3Shape.shape_rect(x,y,w,h)
	local s = ffi.string(ps)
	ffi.C.free(ps)
	return s
end

function shape.rounded_rect(x,y,w,h,rx,ry)
	assert(type(x) == "number", "x is not a number")
	assert(type(y) == "number", "y is not a number")
	assert(type(w) == "number", "w is not a number")
	assert(type(h) == "number", "h is not a number")
	assert(type(rx) == "number", "rx is not a number")
	assert(type(ry) == "number", "ry is not a number")
	local ps = A3Shape.shape_rounded_rect(x,y,w,h,rx,ry)
	local s = ffi.string(ps)
	ffi.C.free(ps)
	return s
end

-- all functions related to percent,the t range from 0 to 1
function shape.angle_at_percent(ass_shape,t)
	assert(type(ass_shape) == "string", "ass_shape is not a string")
	assert(type(t) == "number", "t is not a number")
	return A3Shape.shape_angle_at_percent(ass_shape,t)
end

function shape.length(ass_shape)
	assert(type(ass_shape) == "string", "ass_shape is not a string")
	return A3Shape.shape_length(ass_shape)
end

function shape.percent_at_length(ass_shape,len)
	assert(type(ass_shape) == "string", "ass_shape is not a string")
	assert(type(len) == "number", "len is not a number")
	return A3Shape.shape_percent_at_length(ass_shape,len)
end

function shape.point_at_percent(ass_shape,t)
	assert(type(ass_shape) == "string", "ass_shape is not a string")
	assert(type(t) == "number", "t is not a number")
	local x = ffi.new("double[1]", 1)
	local y = ffi.new("double[1]", 1)
	A3Shape.shape_point_at_percent(ass_shape,t,x,y)
	tbl = {x=x[0],y=y[0]}
	return tbl
	--return x[0],y[0]
end

function shape.slope_at_percent(ass_shape,t)
	assert(type(ass_shape) == "string", "ass_shape is not a string")
	assert(type(t) == "number", "t is not a number")
	return A3Shape.shape_slope_at_percent(ass_shape,t)
end

function shape.bounding(ass_shape) 
	assert(type(ass_shape) == "string", "ass_shape is not a string")
	local x = ffi.new("double[1]", 1)
	local y = ffi.new("double[1]", 1)
	local w = ffi.new("double[1]", 1)
	local h = ffi.new("double[1]", 1)
	A3Shape.shape_bouding(ass_shape,x,y,w,h)
	tbl = {left=x[0],right=x[0]+w[0],top=y[0],bottom=y[0]+h[0],center=x[0]+w[0]/2,middle=y[0]+h[0]/2,width=w[0],height=h[0]}
	return tbl
end

function shape.contains_point(ass_shape,x,y)
	assert(type(ass_shape) == "string", "ass_shape is not a string")
	assert(type(x) == "number", "x is not a number")
	assert(type(y) == "number", "y is not a number")
	return A3Shape.shape_contains_point(ass_shape,x,y)
end

function shape.contains_rect(ass_shape,x,y,w,h)
	assert(type(ass_shape) == "string", "ass_shape is not a string")
	assert(type(x) == "number", "x is not a number")
	assert(type(y) == "number", "y is not a number")
	assert(type(w) == "number", "w is not a number")
	assert(type(h) == "number", "h is not a number")
	return A3Shape.shape_contains_rect(ass_shape,x,y,w,h)
end

function shape.translate(ass_shape,x,y)
	assert(type(ass_shape) == "string", "ass_shape is not a string")
	assert(type(x) == "number", "x is not a number")
	assert(type(y) == "number", "y is not a number")
	local ps = A3Shape.shape_translate(ass_shape,x,y)
	local s = ffi.string(ps)
	ffi.C.free(ps)
	return s
end

-- rotate origin point is (0,0) use translate to move (0,0) to the point you want to rotate from,after rotated translate (0,0) back

function shape.rotate(ass_shape,degree)
	assert(type(ass_shape) == "string", "ass_shape is not a string")
	assert(type(degree) == "number", "degree is not a number")
	local ps = A3Shape.shape_rotate(ass_shape,degree)
	local s = ffi.string(ps)
	ffi.C.free(ps)
	return s
end

function shape.scale(ass_shape,sx,sy)
	assert(type(ass_shape) == "string", "ass_shape is not a string")
	assert(type(sx) == "number", "sx is not a number")
	assert(type(sy) == "number", "sy is not a number")
	local ps = A3Shape.shape_scale(ass_shape,sx,sy)
	local s = ffi.string(ps)
	ffi.C.free(ps)
	return s
end

function shape.shear(ass_shape,sh,sv)
	assert(type(ass_shape) == "string", "ass_shape is not a string")
	assert(type(sh) == "number", "sh is not a number")
	assert(type(sv) == "number", "sy is not a number")
	local ps = A3Shape.shape_shear(ass_shape,sh,sv)
	local s = ffi.string(ps)
	ffi.C.free(ps)
	return s
end

-- boolean operation on ass shape

function shape.united(ass_shape1,ass_shape2) 
	assert(type(ass_shape1) == "string", "ass_shape1 is not a string")
	assert(type(ass_shape2) == "string", "ass_shape2 is not a string")
	local ps = A3Shape.shape_united(ass_shape1,ass_shape2)
	local s = ffi.string(ps)
	ffi.C.free(ps)
	return s
end

function shape.intersected(ass_shape1,ass_shape2) 
	assert(type(ass_shape1) == "string", "ass_shape1 is not a string")
	assert(type(ass_shape2) == "string", "ass_shape2 is not a string")
	local ps = A3Shape.shape_intersected(ass_shape1,ass_shape2)
	local s = ffi.string(ps)
	ffi.C.free(ps)
	return s
end

function shape.subtracted(ass_shape1,ass_shape2) 
	assert(type(ass_shape1) == "string", "ass_shape1 is not a string")
	assert(type(ass_shape2) == "string", "ass_shape2 is not a string")
	local ps = A3Shape.shape_subtracted(ass_shape1,ass_shape2)
	local s = ffi.string(ps)
	ffi.C.free(ps)
	return s
end

--[[
	cap style:   Flat Square Round
	join style:  Miter Bevel Round SvgMiter
]]
function shape.outline(ass_shape,width,cap_style,join_style)
	assert(type(ass_shape) == "string", "ass_shape is not a string")
	assert(type(width) == "number", "width is not a number")
	assert(type(cap_style) == "string", "cap_style is not a string")
	assert(type(join_style) == "string", "join_style is not a string")
	local ps = A3Shape.shape_outline(ass_shape,width,cap_style,join_style)
	local s = ffi.string(ps)
	ffi.C.free(ps)
	return s
end

function shape.pattern_outline(ass_shape,width,cap_style,join_style,pattern_len,space_len,dash_offset)
	assert(type(ass_shape) == "string", "ass_shape is not a string")
	assert(type(width) == "number", "width is not a number")
	assert(type(cap_style) == "string", "cap_style is not a string")
	assert(type(join_style) == "string", "join_style is not a string")
	assert(type(pattern_len) == "number", "pattern_len is not a number")
	assert(type(space_len) == "number", "space_len is not a number")
	assert(type(dash_offset) == "number", "dash_offset is not a number")
	local ps = A3Shape.shape_pattern_outline(ass_shape,width,cap_style,join_style,pattern_len,space_len,dash_offset)
	local s = ffi.string(ps)
	ffi.C.free(ps)
	return s
end

function shape.reverse(ass_shape)
	assert(type(ass_shape) == "string", "ass_shape is not a string")
	new_s = ""
	for shape in string.gmatch(ass_shape,"m [^m$]+") do
		s = string.match(shape,"[%d%-%.]+ [%d%-%.]+")
		for line in string.gmatch(shape,"[lb][^lb]+") do
			if string.match(line,"%a") == "l" then
				s = string.match(line,"[%d%-%.]+ [%d%-%.]+").." l "..s
			else
				bn = 0
				bi = {}
				for point in string.gmatch(line,"[%d%-%.]+ [%d%-%.]+") do
					bn = bn+1
					bi[bn] = point
				end
				for i = 1,bn-1 do
					s = bi[i].." "..s
				end
			s = bi[bn].." b "..s
			end
		end
		s = "m "..s
		new_s = new_s.." "..s
	end
return new_s
end

function shape.bounding_an(ass_shape,mode)
    assert(type(ass_shape) == "string", "ass_shape is not a string")
    assert(type(mode) == "number", "mode is not a number")
	if mode == 7 then
	    new_shape=_G.shape.translate(ass_shape,-_G.shape.bounding(ass_shape).left,-_G.shape.bounding(ass_shape).top)
	elseif mode == 5 then
	    new_shape=_G.shape.translate(ass_shape,-_G.shape.bounding(ass_shape).center,-_G.shape.bounding(ass_shape).middle)
	end
return new_shape
end

function shape.text_to_shape(text,style)
    assert(type(text) == "string","text is not a string")
	assert(type(style) == "table","style is not a table")
    texts=_G.Yutils.decode.create_font(style.fontname,style.bold, style.italic, style.underline, style.strikeout,style.fontsize,xscale,yscale).text_to_shape(text)    
	shape_text=""
	for shape in string.gmatch(texts,"m[^m]+") do
	    local first_point=string.match(shape,"m ([%d%.-]+ [%d%.-]+)")
		local last_point=string.match(shape,"([%d%.-]+ [%d%.-]+) c")
	    if last_point ~= nil then
            shape=string.gsub(shape,"c","l "..last_point)   
		end
		shape_text=shape_text..shape
	end
return shape_text
end

function shape.text_to_pixels(text,style)
    assert(type(text) == "string","text is not a string")
	assert(type(style) == "table","style is not a table")
	texts=_G.Yutils.decode.create_font(style.fontname,style.bold, style.italic, style.underline, style.strikeout,style.fontsize).text_to_shape(text)
	texts=string.gsub(texts,"c","")
	pixels=_G.Yutils.shape.to_pixels(texts)
return pixels
end
	
function shape.vertical(wid,wid2,ass_shape)
    assert(type(ass_shape) == "string", "shape is not a string")
	assert(type(wid) == "number", "wid is not a number")
	assert(type(wid2) == "number", "wid2 is not a number")
    s_left=_G.shape.bounding(ass_shape).left
	s_top=_G.shape.bounding(ass_shape).top
	ass_shape=_G.shape.bounding_an(ass_shape)
	pixels=_G.Yutils.shape.to_pixels(ass_shape)   
    grain={}
    gn=math.ceil(_G.shape.bounding(ass_shape).width/(wid+wid2))
    rect_x={}
    for i=1,gn do
        grain[i]={}
        rect_x[i]=(wid+wid2)*(i-1)
        for j=0,_G.shape.bounding(ass_shape).height do
            grain[i][j]=0
        end
    end
    for i=1,#pixels do
        for j=1,gn do
            if pixels[i].x >= rect_x[j] and pixels[i].x <= rect_x[j]+wid then
                grain[j][pixels[i].y]=grain[j][pixels[i].y]+1
            end
        end
    end
    new_shape=""
    for i=1,gn do
        for j=0,_G.shape.bounding(ass_shape).height do
            if grain[i][j] >= wid/2 then
                if new_shape == "" then
                    new_shape=_G.shape.rect(rect_x[i],j,wid,1)
                else
                    new_shape=_G.shape.united(new_shape,_G.shape.rect(rect_x[i],j,wid,1))
                end
            end
        end
    end
    if wid >= 4 then
        rx=2
    else 
        rx=wid/2
    end
    last_shape=""
    for rect in string.gmatch(new_shape,"m [^m]+") do
        if _G.shape.bounding(rect).height >= 4 then
	        ry=2
	    else 
	        ry=_G.shape.bounding(rect).height/2
	    end
        new_rect=_G.shape.rounded_rect(_G.shape.bounding(rect).left,_G.shape.bounding(rect).top,_G.shape.bounding(rect).width,_G.shape.bounding(rect).height,rx,ry)
	    if last_shape == "" then
            last_shape=new_rect
        else
            last_shape=_G.shape.united(last_shape,new_rect)
        end
    end
	last_shape=_G.shape.translate(last_shape,s_left,s_top)
return last_shape
end

--闪电生成函数用法：Lighting(x1,y1,x2,y2,displace,curDetail,thickness_min,thickness_max)    
--▶x1,y1x2y2：图形起始与结束的坐标位置    
--▶displace：最大位移值(数值越大,线条越曲折)    
--▶curDetail:最小切割值(数值越小,则线条数量越多,每条线也越短,也就是线段被切的越碎)    
--▶thickness_min/max:线条粗细(在min与max范围内随机,如果min与max相等，则为固定粗细)
function shape.lighting(x1,y1,x2,y2,displace,curDetail,thickness_min,thickness_max)
  	pos_table = {}
 	pos_table_temp = {}
 	shape_table = {}
 	shape_table_reverse = {}
  	local function drawLightning(x1,y1,x2,y2,displace)
  		if (displace < curDetail) then
			pos_table[#pos_table+1] = {x1,y1,x2,y2}
 		else 				
			local mid_x = (x1+x2)/2
 			local mid_y = (y1+y2)/2
 			mid_x = mid_x + (math.random(0,1)-0.5) * displace
 			mid_y = mid_y + (math.random(0,1)-0.5) * displace
 			drawLightning(x1,y1,mid_x,mid_y,displace/2)
 			drawLightning(mid_x,mid_y,x2,y2,displace/2)
		end
	end  	
	do 	drawLightning(x1,y1,x2,y2,displace) 	
	end  	
	for var=1,#pos_table do 		
	    shape_table[var] = _G.table.concat(pos_table[var]," ",3,4)  		
	    pos_table_temp[var] = {} 		
	    pos_table_temp[var][3] = pos_table[var][3] 		
	    pos_table_temp[var][4] = pos_table[var][4]+math.random(thickness_min,thickness_max)  		
	    shape_table_reverse[#pos_table-var+1] = _G.table.concat(pos_table_temp[var]," ",3,4)  	
	end
    lighting_shape=string.format("m %d %d l ",x1,y1).._G.table.concat(shape_table," ").." ".._G.table.concat(shape_table_reverse," ")
return 	lighting_shape 
end

--[[
波动函数
shape.wave(shape,wave_center_x,wave_center_y,cycle,dr,wavelength,ti,ellipse_x,ellipse_y)
参数说明：
shape:图形的绘图代码
wave_center_x:波动中心x坐标
wave_center_y:波动中心y坐标
cycle:周期参数，越大波动的越快
dr:最大形变量
wavelength:波长参数
ti:即逐帧时的j,由于无法直接调用因此需要手动输入
ellipse_x:波形x系数，默认1
ellipse_y:波形y系数，默认1
波形系数若为0则该方向上无波动，都为0则无波动效果
]]--
function shape.wave(shape,wave_center_x,wave_center_y,cycle,dr,wavelength,ti,ellipse_x,ellipse_y)
    assert(type(shape) == "string", "shape is not a string")
    assert(type(wave_center_x) == "number", "wave_center_x is not a number")
	assert(type(wave_center_y) == "number", "wave_center_y is not a number")
	assert(type(cycle) == "number", "cycle is not a number")
	assert(type(dr) == "number", "dr is not a number")
	assert(type(wavelength) == "number", "wavelength is not a number")
	assert(type(ti) == "number", "ti is not a number")
	if ellipse_x == nil then
	    ellipse_x=1
    end
    if ellipse_y == nil then
        ellipse_y=1
    end
	function filter(x,y)
	    if ellipse_x == 0 and ellipse_y ~= 0 then
	        x2=x
            if y == wave_center_y then
	    	    y2=y
	    	else
	    	    y2=y+dr*math.sin(cycle*ti+wavelength*(y-wave_center_y))
	    	end
	    elseif ellipse_x ~= 0 and ellipse_y == 0 then
	        y2=y
	    	if x == wave_center_x then
	    	    x2=x
	    	else
	    	    x2=x+dr*math.sin(cycle*ti+wavelength*(x-wave_center_x))
	    	end
	    elseif ellipse_x == 0 and ellipse_y == 0 then
	    	x2=x
	    	y2=y
	    else
	    	distance=(((x-wave_center_x)/ellipse_x)^2+((y-wave_center_y)/ellipse_y)^2)^0.5
	    	if distance == 0 then
	    	    x2=x
	    		y2=y
	    	else
		        x2=wave_center_x+(x-wave_center_x)*(distance+dr*math.sin(cycle*ti+wavelength*(distance)))/distance
		    	y2=wave_center_y+(y-wave_center_y)*(distance+dr*math.sin(cycle*ti+wavelength*(distance)))/distance
	    	end
	    end
    return x2,y2
    end
    wave_shape=_G.Yutils.shape.filter(shape,function(x,y) return filter(x,y) end)
return wave_shape
end

--[[
function draw(ass_shape,point_n)
	shapes={}
	shapes[1]=_G.shape.rect(_G.shape.point_at_percent(ass_shape,0).x,_G.shape.point_at_percent(ass_shape,0).y,1,1)
	for i=2,point_n do
	    shapes[i]=_G.shape.united(shapes[i-1],_G.shape.rect(_G.shape.point_at_percent(ass_shape,(i-1)/point_n).x,_G.shape.point_at_percent(ass_shape,(i-1)/point_n).y,1,1))
	end
	maxloop(point_n)
return shapes[j]
end	

_G.shape = shape
]]--

function shape.suipian(shape,num)
	left=_G.shape.bounding(shape).left
	top=_G.shape.bounding(shape).top
	shape=_G.shape.bounding_an(shape,7)
	shape_sp={}
	if num == 1 then
	    shape_sp[1]=shape
	else 
	    width=_G.shape.bounding(shape).width
	    height=_G.shape.bounding(shape).height
	    b_rect=_G.shape.rect(0,0,width,height)
		x0=math.random(width/5,width/5*4)
	    y0=math.random(height/5,height/5*4)
	    liewen=string.format("m %d %d ",x0,y0)
		theta=math.random(360)
		r=width+height
		liewen=liewen..string.format("l %d %d l %d %d l %d %d ",x0+r*math.cos(math.rad(theta)),y0+r*math.sin(math.rad(theta)),x0+r*math.cos(math.rad(theta+1)),y0+r*math.sin(math.rad(theta+1)),x0,y0)
		for i=2,num do
	        theta=theta+360/num*math.random(80,120)/100
			liewen=liewen..string.format("l %d %d l %d %d l %d %d ",x0+r*math.cos(math.rad(theta)),y0+r*math.sin(math.rad(theta)),x0+r*math.cos(math.rad(theta+1)),y0+r*math.sin(math.rad(theta+1)),x0,y0)
        end
		shape_lw=_G.shape.subtracted(b_rect,liewen)
		sp_i=0
		for lw in string.gmatch(shape_lw,"m[^m]+") do
		    sp_i=sp_i+1
			shape_sp[sp_i]=_G.shape.translate(_G.shape.intersected(shape,lw),left,top)
		end
	end
return shape_sp
end

function shape.fragment(ass_shape,num)
    sp={}
	if num == 0 then
	    sp[1]=ass_shape
	else
	    shape_an=_G.shape.bounding_an(ass_shape,7)
		width=_G.shape.bounding(ass_shape).width
		height=_G.shape.bounding(ass_shape).height
		left=_G.shape.bounding(ass_shape).left
		top=_G.shape.bounding(ass_shape).top	
		rect_shape=_G.shape.rect(0,0,width,height)
		r=width+height
		for i=1,num do
		    if th then
			    th=th+180/num*math.random(90,110)/100
			else 
			    th=math.random(180)
			end
			local theta=math.rad(th)
			local x=math.random(width/5,width*4/5)
			local y=math.random(height/5,height*4/5)
			local crackle_shape=string.format("m %d %d l %d %d l %d %d l %d %d l %d %d ",x+r*math.cos(theta),y+r*math.sin(theta),x+r*math.cos(theta)+math.sin(theta),y+r*math.sin(theta)+math.cos(theta),x-r*math.cos(theta)+math.sin(theta),y-r*math.sin(theta)+math.cos(theta),x-r*math.cos(theta),y-r*math.sin(theta),x+r*math.cos(theta),y+r*math.sin(theta))
			rect_shape=_G.shape.subtracted(rect_shape,crackle_shape)
		end
		sp_i=0
		for a in string.gmatch(rect_shape,"m[^m]+") do
		    sp_i=sp_i+1
			sp[sp_i]=_G.shape.translate(_G.shape.intersected(shape_an,a),left,top)
		end
	end
return sp
end

return shape