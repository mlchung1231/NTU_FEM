function dist_plot ( p, t, fd )

%*****************************************************************************80
%
%% DIST_PLOT displays a plot of the distance function.
%
%  Licensing:
%
%    This code is distributed under the GNU LGPL license.
%
%  Modified:
%
%    06 February 2006
%
%  Author:
%
%    John Burkardt
%
%  Reference:
%
%    Per-Olof Persson, Gilbert Strang,
%    A Simple Mesh Generator in MATLAB,
%    SIAM Review,
%    Volume 46, Number 2, June 2004, pages 329-345.
%
%  Input:
%
%    real P(NP,2), the coordinates of a set of nodes in 2D.
%
%    integer T(NT,3), a list of the nodes which make up each 
%    triangle in the mesh.
%
%    pointer FD, an inline function or the name of a file containing the
%    signed distance function.
%
  d = fd ( p );

  h = trisurf ( t, p(:,1), p(:,2), d, 'FaceColor', 'interp', ...
    'EdgeColor', 'interp' );

  view ( 2 )
  axis equal
  axis off

  return
end
