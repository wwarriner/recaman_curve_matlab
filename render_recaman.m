function [ fh, axh, sh ] = render_recaman( ...
    r, ...
    background_color, ...
    colormap_string, ...
    target_dpi ...
    )

%% DEFAULT INPUTS
if nargin < 4; target_dpi = [ 960 540 ]; end
if nargin < 3; colormap_string = 'hsv'; end
if nargin < 2; background_color = 'k'; end
if nargin < 1; r = recaman( 100 ); end

%% PREALLOCATION
CURVE_RESOLUTION = 100;
n = length( r );
curve_point_count = n * CURVE_RESOLUTION;
X = zeros( curve_point_count, 1 );
Y = zeros( curve_point_count, 1 );
draw_above_x_axis = true;

%% CREATE ARCS
for i = 2 : n
    
    [ x, y ] = get_recaman_arc_points( ...
        draw_above_x_axis, ...
        r( i - 1 ), ...
        r( i ), ...
        CURVE_RESOLUTION ...
        );
    start_index = ( ( i - 1 ) * CURVE_RESOLUTION ) + 1;
    finish_index = i * CURVE_RESOLUTION;
    X( start_index : finish_index ) = x;
    Y( start_index : finish_index ) = y;
    draw_above_x_axis = ~draw_above_x_axis;
    
end

%% PREPARE FIGURE
[ fh, axh ] = prepare_figure_and_axes( ...
    background_color, ...
    target_dpi, ...
    colormap_string, ...
    n, ...
    max( r ) ...
);

%% RENDER
Z = zeros( curve_point_count, 1 );
color_range = linspace( 0, 1, curve_point_count ).';
sh = surface( [ X X ], [ Y Y ], [ Z Z ], [ color_range color_range ] );
sh.FaceColor = 'none';
sh.EdgeColor = 'interp';
sh.EdgeAlpha = 0.5;

end


function [ fh, axh ] = prepare_figure_and_axes( ...
    background_color, ...
    target_dpi, ...
    colormap_string, ...
    n, ...
    maximum_r ...
    )

fh = figure( 'color', background_color );
fh.Position = [ 10 10 target_dpi ];

colormap( fh, colormap_string );

axh = axes( fh );
hold( axh, 'on' );
axis( axh, 'equal' );
axis( axh, 'off' );
axh.XLim = [ -1, maximum_r + 1 ];
y_limit = ( n / 2 ) + 1;
axh.YLim = [ -y_limit, y_limit ];

end


function [ x, y ] = get_recaman_arc_points( ...
    draw_above_x_axis, ...
    previous_r, ...
    current_r, ...
    resolution ...
    )

if draw_above_x_axis
    angle_limits = [ 0 pi ];
else
    angle_limits = [ -pi 0 ];
end
mid_x = ( previous_r + current_r ) / 2;
radius = abs( previous_r - current_r ) / 2;
[ x, y ] = get_arc_points( angle_limits, radius, [ mid_x 0 ], resolution );
draw_clockwise = ...
    ( draw_above_x_axis && previous_r < current_r ) ...
    || ( ~draw_above_x_axis && current_r < previous_r );
if draw_clockwise
    x = flip( x );
    y = flip( y );
end

end


function [ x, y ] = get_arc_points( angle_limits, radius, origin, step_count )

t = linspace( angle_limits( 1 ), angle_limits( 2 ), step_count );
x = ( radius * cos( t ) ) + origin( 1 );
y = ( radius * sin( t ) ) + origin( 2 );

end

