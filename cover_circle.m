
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
