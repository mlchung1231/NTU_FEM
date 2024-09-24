coor = [];
A = [0:4]; 
for i = 1:3
    coor = horzcat(coor,A);
end
B = [zeros(1, 5), ones(1, 5), 2*ones(1, 5)];
coor = vertcat(coor,B);

conn = [];
for j = [0,5]
    for i = 1:4
        i = j + i;
        C = [i;i+1;i+6;i+5];
        conn = horzcat(conn,C);
    end
end

filename = 'hw2_2_mesh.h5';
h5create(filename, '/coor', size(coor));
h5write(filename, '/coor', coor);

h5create(filename, '/conn', size(conn));
h5write(filename, '/conn', conn);
