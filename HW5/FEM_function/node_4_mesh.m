function [p, t] = node_4_mesh(L, h, ele_size)
    p = [];
    t = [];
    index = 1;
    for i = 0:ele_size:L
        for j = 0:ele_size:h
            new_node = [i; j];
            p = [p, new_node];
            if mod(index, h/ele_size +1) ~= 0
                if size(t,2) < L*h/ele_size^2
                    new_ele = [index; index+(h/ele_size+1); index+(h/ele_size+1)+1; index+1];
                    t = [t, new_ele];
                end
            end
            index = index + 1;
        end
    end
end