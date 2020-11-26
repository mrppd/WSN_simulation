
function main()
    clear all;
    clc;
    MAX_GEN = 200;         %number of generation
    N = 5;                 %number of termite
    p = 0.10;                %evaporation rate
    load('E:\Work\research work\Nir research\matlab\map287_287_1000_540.mat');
    map_size = size(map)-10;
    ref_map = uint16(map);  %ref_map is used to teat coordinate as a node
    map = uint8(map);
    total_points=1;
    for i=1: map_size(1)
        for j=1: map_size(2)
            if(ref_map(i,j)==1)
                ref_map(i,j)=total_points;
                total_points = total_points+1;
            end;
        end;
    end;
    total_points = total_points-1;
    %figure, imshow(map);
    
    co = rand_number(1, total_points);
     for i=1: map_size(1)
        for j=1: map_size(2)
            if(ref_map(i,j)==co)
                sink.xpos = i;
                sink.ypos = j;
            end;
        end;
    end;
    [sink.xpos, sink.ypos] = deal(105, 121);
    [ref_map(sink.xpos, sink.ypos), sink.xpos, sink.ypos] 
    %{
    for i=1:50
        for j=1:50
            %[ref_map(250+j, 250+i), sink.xpos, sink.ypos] 
            [ref_map(250+j, 250+i), 250+i, 250+j]
        end;
    end;
    %}
  
    
    cov_map = zeros(map_size(1), map_size(2));  %used to hold the sensor coverage not positions
    final_coverage = zeros(map_size(1), map_size(2));  %used to hold the valid sensor coverage not positions
    sensor_map = zeros(map_size(1), map_size(2));  %used to hold the sensor positions not coverage
    final_sensor_count = zeros(map_size(1), map_size(2));
    t  = zeros(map_size(1), map_size(2));  %used to hold the pheromone
    con_map(total_points+5, total_points+5)=uint8(0);
    sensor_selected = 0;
    %s = zeros(map_size(1), map_size(2), map_size(1), map_size(2));
    %l = zeros(map_size(1), map_size(2), map_size(1), map_size(2));
   
    for i=1:N
        [x,y]=rand_coordinate_rec(map_size);
        termite(i).num = i;
        termite(i).xpos = int16(x);
        termite(i).ypos = int16(y);
        termite(i).rad = 11;%int16((1/2)*map_size(1));
        termite(i).complete = 0;
        %ter(x,y)=1;
    end;
    %figure, imshow(ter);
    
    for i=1: map_size(1)
        for j=1: map_size(2)
            if(map(i,j)>0)
                t(i,j)=(1/total_points);
            end;
        end;
    end;
    t(sink.xpos, sink.ypos)= 1;
    
    gen=1;
    c = 1;
    while(gen<= MAX_GEN)
        covered_points=0;
        for i=1: map_size(1)
            for j=1: map_size(2)
                if(cov_map(i,j)>0)
                    covered_points = covered_points+1;
                end;
                if(sensor_map(i,j)>0)
                    sensor_selected = sensor_selected + 1;
                end;
            end;
        end;
        %covered_points
        %total_points
        coverage = 100*(covered_points/(map_size(1)*map_size(2)));
        [gen, coverage]
        if(coverage==0)
            fitness = 0;
        else
            fitness = (coverage*coverage)/sensor_selected;
        end;
        
        if(gen>1)
            for i=1: map_size(1)
                for j=1: map_size(2)
                    if(map(i,j)>0)
                        t(i,j)=(p*t(i,j))+(1/(fitness+1));
                    end;
                end;
            end;
        end;
        t(sink.xpos, sink.ypos)= 10;
    
        
        for tn=1: N
            
            if(map(termite(tn).xpos, termite(tn).ypos)>0 && termite(tn).complete==0)
                cov_map = fill_coverage_area(cov_map, map_size, termite(tn).xpos, termite(tn).ypos, 22, 1);
                sensor_map(termite(tn).xpos, termite(tn).ypos)=1;
                
                if(termite(tn).xpos==sink.xpos && termite(tn).ypos==sink.ypos);
                    sensor_map(termite(tn).xpos, termite(tn).ypos)=0;
                    cov_map = fill_coverage_area(cov_map, map_size, termite(tn).xpos, termite(tn).ypos, 22, 0);
                    termite(tn).complete = 1;
                    continue;
                end;
                clearvars coordinate;
                [coordinate, num] = read_near_by_sensor(map, cov_map, sensor_map, map_size, termite(tn).xpos, termite(tn).ypos, 22);
                
       
                sump=0;
                tmp_prob=0;
                tmpind = 99999;
                for i=1: num
                    tmul = t(coordinate(i).xpos, coordinate(i).ypos)*coordinate(i).uncov_points*(1-coordinate(i).already_sensor);
                    sump = sump + tmul;
                    
                    %[coordinate(i).xpos, coordinate(i).ypos, coordinate(i).uncov_points, coordinate(i).already_sensor]
                end;
                for i=1: num
                    tmul = t(coordinate(i).xpos, coordinate(i).ypos)*coordinate(i).uncov_points*(1-coordinate(i).already_sensor);
                    coordinate(i).prob = tmul/sump;
                    if(coordinate(i).prob > tmp_prob)
                        tmp_prob = coordinate(i).prob;
                        tmpind = i;
                    end;
                end;
                %{
                if(tmpind==99999)
                    tmp_prob=0;
                    for i=1: num
                        tmul = t(coordinate(i).xpos, coordinate(i).ypos);
                        %coordinate(i).prob = tmul/sump;
                        if(tmul > tmp_prob)
                            tmp_prob = tmul;
                            tmpind = i;
                        end;
                    end;
                end;
                %}
                if(tmpind==99999)
                    tmpind = rand_number(1, num);
                    %termite(tn).xpos = coordinate(tmpind).xpos;
                    %termite(tn).ypos = coordinate(tmpind).ypos;
                    %[termite(tn).xpos, termite(tn).ypos] = rand_coordinate_cir(map, map_size, termite(tn).xpos, termite(tn).ypos, termite(tn).rad); %random walk by termite
                    %continue;
                end;
                
                %[ ref_map(termite(tn).xpos, termite(tn).ypos), ref_map(coordinate(tmpind).xpos, coordinate(tmpind).ypos)]
                con_map(ref_map(termite(tn).xpos, termite(tn).ypos), ref_map(coordinate(tmpind).xpos, coordinate(tmpind).ypos)) = tn;
                con_map(ref_map(coordinate(tmpind).xpos, coordinate(tmpind).ypos), ref_map(termite(tn).xpos, termite(tn).ypos)) = tn;
                con(c).xpos1 = termite(tn).xpos;
                con(c).ypos1 = termite(tn).ypos;
                con(c).xpos2 = coordinate(tmpind).xpos;
                con(c).ypos2 = coordinate(tmpind).ypos;
                con(c).termite = tn; 
                c = c + 1;
                
                termite(tn).xpos = coordinate(tmpind).xpos;
                termite(tn).ypos = coordinate(tmpind).ypos;

                
                %ref_map(termite(tn).xpos, termite(tn).ypos)
            else
                [termite(tn).xpos, termite(tn).ypos] = rand_coordinate_cir(map, map_size, termite(tn).xpos, termite(tn).ypos, termite(tn).rad); %random walk by termite
                %'Ramdom walk'
            end;
            %%%%%%%%%%%%%%%%
        end;
        if(mod(gen, 500)==0)
            figure, imshow(cov_map);
        end;
        gen = gen + 1;
    end;
    figure, imshow(cov_map);


    %final_coverage = fill_coverage_area(final_coverage, map_size, sink.xpos, sink.ypos, 22, 1);
    for tm=1:N
        if(termite(tm).complete==1)
            for j=1: c-1
                if(con(j).termite==tm)
                    final_coverage = fill_coverage_area(final_coverage, map_size, con(j).xpos1, con(j).ypos1, 22, 1);
                    final_coverage = fill_coverage_area(final_coverage, map_size, con(j).xpos2, con(j).ypos2, 22, 1);
                end;
            end;
        end;
        [tm, termite(tm).complete]
    end;
    
    final_coverage = uint8(final_coverage);
    increment = uint8(250/max(max(final_coverage)));
    final_coverage = final_coverage*increment;
    final_coverage = fill_coverage_area(final_coverage, map_size, sink.xpos, sink.ypos, 22, 250);
    
    sensor_cnt = 0;
    for tm=1:N
        if(termite(tm).complete==1)
            for j=1: c-1
                if(con(j).termite==tm)
                    final_coverage = siLine(final_coverage, con(j).xpos1, con(j).ypos1, con(j).xpos2, con(j).ypos2, 255);
                    if(final_sensor_count(con(j).xpos1, con(j).ypos1)==0)
                        final_sensor_count(con(j).xpos1, con(j).ypos1)=1;
                        sensor_cnt = sensor_cnt + 1;
                    end;
                    if(final_sensor_count(con(j).xpos2, con(j).ypos2)==0)
                        final_sensor_count(con(j).xpos2, con(j).ypos2)=1;
                        sensor_cnt = sensor_cnt + 1;
                    end;
                end;
            end;
        end;
    end;    
    
    covered_points = 0;
    sensor_selected = 0;
    for i=1: map_size(1)
        for j=1: map_size(2)
            if(final_coverage(i,j)>0)
                covered_points = covered_points+1;
            end;
        end;
    end;
    coverage = 100*(covered_points/(map_size(1)*map_size(2)));
    
    [coverage, sensor_cnt]
    figure, imshow(final_coverage);
    

end



function ar = fill_coverage_area(ar, map_size, x, y, R, fill_by)
    %figure, imshow(uint8(ar));
    for k=-R:R
        for p=-R:R
            if((k*k)+(p*p) <= (R*R))
                if((x+k)<=map_size(1) && (y+p)<=map_size(2) && (x+k)>=1 && (y+p)>=1)
                    if(fill_by==0 || fill_by==250)
                        ar(x+k, y+p) = fill_by;
                    else
                        ar(x+k, y+p) = ar(x+k, y+p)+fill_by;
                    end;
                end;
            end;
        end;
    end;
    %figure, imshow(uint8(ar));
end

function [coordinate, num] = read_near_by_sensor(ar, cov_map, sensor_map, map_size, x, y, R)
    %figure, imshow(uint8(ar));
    num = 1;
    for k=-R:R
        for p=-R:R
            if((k*k)+(p*p) <= (R*R))
                if((x+k)<=map_size(1) && (y+p)<=map_size(2) && (x+k)>=1 && (y+p)>=1)
                    if(ar(x+k, y+p)>0 && (x+k)~=x && (y+p)~=y)
                        %ar(x+k, y+p) = 50;
                        coordinate(num).xpos= x+k;
                        coordinate(num).ypos= y+p;
                        num = num + 1;
                    end;
                end;
            end;
        end;
    end;
    num=num-1;
    for co=1:num
        uncov=0;
        for k=-R:R
            for p=-R:R
                if((k*k)+(p*p) <= (R*R))
                    if((coordinate(co).xpos+k)<=map_size(1) && (coordinate(co).ypos+p)<=map_size(2) && (coordinate(co).xpos+k)>=1 && (coordinate(co).ypos+p)>=1)
                         if(cov_map(coordinate(co).xpos+k, coordinate(co).ypos+p)==0)
                             uncov = uncov+1;
                         end;
                    end;
                end;
            end
        end;
        coordinate(co).uncov_points = uncov;

        if(sensor_map(coordinate(co).xpos, coordinate(co).ypos)==1)
            coordinate(co).already_sensor=1;
        else
            coordinate(co).already_sensor=0;
        end;
        
    end;
    
    %figure, imshow(uint8(ar));
end

function x = rand_number(low, up)
    x = int16((up-low)*rand()+low);
end

function [x, y] = rand_coordinate_rec(map_size)
    x = 9999999;
    y = 9999999;
    while(x>map_size(1) || y>map_size(2) || x<=0 || y<=0)
        x = uint16((map_size(1)-1)*rand()+1);
        y = uint16((map_size(2)-1)*rand()+1);
    end;
end

function [a, b] = rand_coordinate_cir(ar, map_size, xx, yy, R)
    size_ar = size(ar);
    a = 9999999;
    b = 9999999;
    while(a>map_size(1) || b>map_size(2) || a<=0 || b<=0)
        x = rand();
        y = rand();
        if(x>y)
            [y,x]=deal(x,y);
        end;
        a = int16(y*R*cos(2*pi*(x/y)));
        b = int16(y*R*sin(2*pi*(x/y)));
        a = xx + a;
        b = yy + b;
        %[a, b]
    end;
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

