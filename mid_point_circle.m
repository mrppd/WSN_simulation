

function main()

    ar = zeros (1500, 1500);
    ar= uint8(ar);
    ii=0;
    for m=0:300
       % [ii, ar] = midpoitcircle(ar, m, 400, 400, ii);
    end;
    tic
    jj=0;
    for k=-50:50
        for p=-50:50
             if((k*k)+(p*p) <= (50*50-1))
                 ar(400+k, 400+p)=50;
               
             end;
              jj=jj+1;
        end;
    end;
    jj
    toc
   
    %{
   r = 300;
   r2 = r*r;
   area = r2*4;
   rr = r*2;
   for m=0:area
    k = (mod(m, rr)-r);
    p = int32((m / rr) - r);
    if((k*k)+(p*p) <= (300*300-1))
        ar(400+k, 400+p)= 255;
    end;
   end;
   %}
    
   %{ 
    i=5;
    while i<90
        j=5;
        while j<90
            [mm, ar] = midpoitcircle(ar, 5, i, j, 255);
            j=j+15;
        end;
        i=i+15;
    end;
    %}
    tic
    [mm, ar] = midpoitcircle(ar,50, 1100, 400, 255);
    toc
    mm
    %ar = siLine(ar, 400, 400, 304, 800, 255);
    figure, imshow(ar);
end

function ar = midpointline(ar, x0, y0, x1, y1, value, zone)
    dx = x1-x0;
    dy = y1-y0;
    d = 2*dy - dx;
    incrE = 2*dy;
    incrNE = 2*(dy-dx);
    x = x0;
    y = y0;
    ar = draw8way(ar, x, y, value, zone);
    while(x<x1)
        if(d <= 0)
            d= d+incrE;
            x = x+1;
        else
            d = d +incrNE;
            x = x+1;
            y = y+1;
        end;
        ar = draw8way(ar, x, y, value, zone);
    end;
 end


function ar = draw8way(ar, x, y, value, zone)
    if(zone==0) 
        ar(x, y) = value;
    elseif(zone==1) 
            ar(y, x) = value;
    elseif(zone==2) 
            ar(-y, x) = value;
    elseif(zone==3) 
            ar(-x, y) = value;
    elseif(zone==4) 
            ar(-x, -y) = value;
    elseif(zone==5) 
            ar(-y, -x) = value;
    elseif(zone==6) 
            ar(y, -x) = value;
        else
            ar(x, -y) = value;
    end;
end
 
function ar = siLine(ar, x0, y0, x1, y1, value)

    dx = x1 - x0;
    dy = y1 - y0;

    if(abs(dx) >= abs(dy)) %for zone 0, 3, 4 and 7
        if(x1 >= x0)
            if(y1 >= y0) 
                ar = midpointline(ar, x0, y0, x1, y1, value, 0);
            else
                ar = midpointline(ar, x0, -y0, x1, -y1, value, 7);
            end;
        else
            if(y1 >= y0)
                ar = midpointline(ar, -x0, y0, -x1, y1, value, 3);
            else
                ar = midpointline(ar, -x0, -y0, -x1, -y1, value, 4);
            end;
        end;
    else   %for zone 1, 2, 5 and 6
        if(x1 >= x0)
            if(y1 >= y0)
                ar = midpointline(ar, y0, x0, y1, x1, value, 1);
            else
                ar = midpointline(ar, -y0, x0, -y1, x1, value, 6);
            end;
        else
            if(y1 >= y0)
                ar = midpointline(ar, y0, -x0, y1, -x1, value, 2);
            else
                ar = midpointline(ar, -y0, -x0, -y1, -x1, value, 5);
            end;
        end;
    end;
end

 
 function [ii, ar] = midpoitcircle(ar, radius, oy, ox, value)
    x=0;
    ii = 0;
    y= int32(radius);
    d = int32(1-radius);
    ar = siLine(ar, ox, oy, x+ox+1, y+oy+1, value);
    ar = siLine(ar, ox, oy, -x+ox+1, y+oy+1, value);
    ar = siLine(ar, ox, oy, x+ox+1, -y+oy+1, value);
    ar = siLine(ar, ox, oy, -x+ox+1, -y+oy+1, value);
    %ar(x+ox+1, y+oy+1)=value;
    %ar(-x+ox+1, y+oy+1)=value;
    %ar(x+ox+1, -y+oy+1)=value;
    %ar(-x+ox+1, -y+oy+1)=value;

    ar = siLine(ar, ox, oy, y+ox+1, x+oy+1, value);
    ar = siLine(ar, ox, oy, -y+ox+1, x+oy+1, value);
    ar = siLine(ar, ox, oy, y+ox+1,-x+oy+1, value);
    ar = siLine(ar, ox, oy, -y+ox+1, -x+oy+1, value);
    %ar(y+ox+1, x+oy+1)=value;
    %ar(-y+ox+1, x+oy+1)=value;
    %ar(y+ox+1, -x+oy+1)=value;
    %ar(-y+ox+1, -x+oy+1)=value;
    while(y>x)
        if(d<0)
            d = d +(2*x+3);
        else
            d = d + (2*(x-y)+5);
            y=y-1;
        end;
        x=x+1;
        ar = siLine(ar, ox, oy, x+ox+1, y+oy+1, value);
        ar = siLine(ar, ox, oy, -x+ox+1, y+oy+1, value);
        ar = siLine(ar, ox, oy, x+ox+1, -y+oy+1, value);
        ar = siLine(ar, ox, oy, -x+ox+1, -y+oy+1, value);

        ar = siLine(ar, ox, oy, y+ox+1, x+oy+1, value);
        ar = siLine(ar, ox, oy, -y+ox+1, x+oy+1, value);
        ar = siLine(ar, ox, oy, y+ox+1,-x+oy+1, value);
        ar = siLine(ar, ox, oy, -y+ox+1, -x+oy+1, value);
        ii=ii+1;
    end;
end