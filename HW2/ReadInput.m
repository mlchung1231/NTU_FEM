function [coor, conn] = ReadInput(filename)
    coor = h5read(filename, '/coor');
    conn = h5read(filename, '/conn');
end