coor = [0 0; 1 0; 2 0; 0.5 3^0.5/2; 1.5 3^0.5/2; 1 3^0.5]; 
conn = [1 2 4; 2 4 5; 2 3 5; 4 5 6];
coor = coor';
conn = conn';

filename = 'hw2_1_mesh.h5';
if exist(filename, 'file') == 2
    delete(filename);
end

h5create(filename, '/coor', size(coor));
h5write(filename, '/coor', coor);

h5create(filename, '/conn', size(conn));
h5write(filename, '/conn', conn);

