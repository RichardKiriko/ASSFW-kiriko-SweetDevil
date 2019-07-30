--彩色绘图函数，其实可以每一部分单独做一行，这个只是整合了一下，可以直接处理彩色图形
--tbl是之前做的处理彩色图形（配合ai插件）时的图形表，表里每一个元素都是table（其中包含text：绘图代码和color：颜色两部分）
--acc是表示精度（accuracy）
--start_t,draw_t,move_t,end_t分别是开始时间，绘图时间，结尾运动时间，结束时间
--x,y是图形定位用的基点
--move_scale是最后运动时扩散的比例
--dx,dy是在扩散的基础上终点的偏移值
--line 13
function draw_shapes(tbl,acc,start_t,draw_t,move_t,end_t,x,y,move_scale,dx,dy)
    if start_t+draw_t+move_t > end_t then
	    end_t=start_t+draw_t+move_t
	end
	len={}
	len[#tbl+1]=0
	for i=1,#tbl do
	    len[i]=math.ceil(_G.shape.length(tbl[i].text)*acc)
		len[#tbl+1]=len[#tbl+1]+len[i]
	end
	maxloop(len[#tbl+1])
	shape_i=1
	local function counter(len_tbl,loop_i,n)
	    if loop_i <= len_tbl[n] then
		    loop_pos={i=n,j=loop_i}
		else
		    counter(len_tbl,loop_i-len_tbl[n],n+1)
		end
	end
	do counter(len,j,1)
	end
	retime("abs",start_t+(loop_pos.j-1)/len[loop_pos.i]*draw_t,end_t)
	start_x=x+_G.shape.point_at_percent(tbl[loop_pos.i].text,(loop_pos.j-1)/len[loop_pos.i]).x
	start_y=y+_G.shape.point_at_percent(tbl[loop_pos.i].text,(loop_pos.j-1)/len[loop_pos.i]).y
	end_x=start_x+dx+(start_x-x)*move_scale
	end_y=start_y+dy+(start_y-y)*move_scale
	tags=string.format("\\move(%d,%d,%d,%d,%d,%d)\\c%s",start_x,start_y,end_x,end_y,line.duration-move_t,line.duration,tbl[loop_pos.i].color)
return 	tags
end
--在一个区域里随机生成些小矩形，然后加blur模拟雾状效果
--line 14
function fog(width,height,p)
	fog_shape=""
	for i=1,width*height*p do
	    local x=math.random(width)
		local y=math.random(height)
	    fog_shape=fog_shape..string.format("m %d %d l %d %d l %d %d l %d %d",x,y,x+1,y,x+1,y+1,x,y+1)
	end
return fog_shape
end
----------------------------上面两个是直接放在ass里的两个函数，下面的是在shape.lua里修改/添加的几个函数-------------------------
--修改的部分
--添加了一些可调用的数据
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

--添加的部分

--文字矢量化，将yutils里的text_to_shape写在shape库里（用起来方便点），同时确保图形是闭合的（否则在用outline这类函数时会缺失线条）
function shape.text_to_shape(text,style)
    assert(type(text) == "string","text is not a string")
	assert(type(style) == "table","style is not a table")
    texts=_G.Yutils.decode.create_font(style.fontname,style.bold, style.italic, style.underline, style.strikeout,style.fontsize,xscale,yscale).text_to_shape(text)    
	shape_text=""
	for shape in string.gmatch(texts,"m[^m]+") do
	    local first_point=string.match(shape,"m ([%d%.-]+ [%d%.-]+)")
		local last_point=string.match(shape,"([%d%.-]+ [%d%.-]+) c")
	    if last_point ~= nil then
            shape=string.gsub(shape,"c","l "..first_point)   
		end
		shape_text=shape_text..shape
	end
return shape_text
end

--碎片化，返回碎片绘图代码的集合
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

--对齐，提供7（将0,0点定到真实包含该图形的矩形的左上角）和5（将0,0点定到真实包含该图形的矩形的中心）两种（其他的感觉用不到）
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