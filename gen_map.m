
function main()
    clc;
    size_x = 400;
    size_y = 400;
    net_points = 2000;
    common_points=0;
    map = zeros(size_x+10, size_y+10);
    for i=1:net_points
        sq = (size_x-1)*rand(2,1)+1;
        a = uint32(sq(1));
        b = uint32(sq(2));
        if(map(a, b)==1)
            common_points = common_points + 1;
        end;
        map(a, b)=1;
    end;
    common_points
    save(strcat('e:/Work/research work/Nir research/matlab/map_',num2str(size_x),'_',num2str(size_y),'_',num2str(net_points),'_', num2str(int32(1000*rand())),'.mat'), 'map');
    figure, imshow(map);

end