clc;
ar = zeros(1100, 1100);
ar = uint8(ar);
R=100;
for k=-R:R
   for p=-R:R
      if((k*k)+(p*p) <= (R*R))
        ar(300+k, 300+p) = ar(300+k, 300+p) + 50;    
      end;
   end;
end;

for k=-R:R
   for p=-R:R
      if((k*k)+(p*p) <= (R*R))
        ar(400+k, 300+p) = ar(400+k, 300+p) + 50;    
      end;
   end;
end;

for k=-R:R
   for p=-R:R
      if((k*k)+(p*p) <= (R*R))
        ar(400+k, 400+p) = ar(400+k, 400+p) + 50;    
      end;
   end;
end;
tic;
for f=1:5000
    %xy=rand(2,1);
    x = rand();
    y = rand();
    %y=rand();
    if(x>y)
        [y,x]=deal(x,y);
    end;
    a = int32(y*R*cos(2*pi*(x/y)));
    b = int32(y*R*sin(2*pi*(x/y)));
    ar(400+a, 400+b)=255;
end;
toc;



tic;
for f=1:5000
    e= ((50-0)*rand(3,1));
    t = 2*pi*e(1);
    u = e(2)+e(3);
    
    if(u>R) 
      r = 2-u; 
    else
        r = u;
    end;
    a = int32(r*cos(t));
    b = int32(r*sin(t));
    ar(400+a, 800+b)=255;
end;
toc;

for i=1:1000
sq = (287-1)*rand(2,1)+1;
a = uint32(sq(1));
b = uint32(sq(2));
ar(700+a, 400+b)=200;
end;


    figure, imshow(ar);