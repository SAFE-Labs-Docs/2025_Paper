function cmap = createCustomSaturationColormap(rgb_input, N)
% createCustomSaturationColormap Generates a colormap with white at the start,
% black at the end, and the input RGB color with varying saturation levels
% in between.
%
% Inputs:
%   rgb_input - A 1x3 vector representing the RGB color [R, G, B].
%               Values should be between 0 and 1. This color will be
%               the "peak" color in the map.
%   N         - (Optional) The number of colors in the colormap.
%               Default is 256. Must be an integer >= 3.
%
% Output:
%   cmap      - An N x 3 matrix representing the colormap.

% --- Input Argument Handling & Validation ---
if nargin < 1
    error('MATLAB:createCustomSaturationColormap:NotEnoughInputs', ...
          'At least one input argument (rgb_input) is required.');
end
if nargin < 2 || isempty(N)
    N = 256; % Default number of colors
end

if ~isnumeric(rgb_input) || ~isequal(size(rgb_input), [1, 3])
    error('MATLAB:createCustomSaturationColormap:InvalidRgbInput', ...
          'rgb_input must be a 1x3 numeric vector.');
end
if any(rgb_input < 0) || any(rgb_input > 1)
    error('MATLAB:createCustomSaturationColormap:RgbInputOutOfRange', ...
          'RGB values in rgb_input must be between 0 and 1.');
end

if ~isnumeric(N) || ~isscalar(N) || N < 3 || floor(N) ~= N
    error('MATLAB:createCustomSaturationColormap:InvalidN', ...
          'N must be a scalar integer greater than or equal to 3.');
end

% --- Convert target RGB to HSV ---
% This hsv_target is the "peak" color around which saturation/value varies.
hsv_target = rgb2hsv(rgb_input);
H_target = hsv_target(1);
S_target = hsv_target(2);
V_target = hsv_target(3);

% If the input color is grayscale (S=0), Hue is undefined (rgb2hsv sets it to 0).
% We'll keep Hue constant; for grayscale, this doesn't affect the color.
if S_target == 0
    H_target = 0; % Hue is irrelevant for S=0, set to 0 for consistency.
end

% --- Define anchor points in HSV for interpolation ---
% White equivalent (same hue as target, Sat=0, Val=1)
hsv_white_equiv = [H_target, 0, 1];
% Black equivalent (same hue as target, Sat=0, Val=0)
% Saturation will also ramp down to 0 on the way to black.
hsv_black_equiv = [H_target, 0, 0];

% --- Determine pivot point for the target color ---
% The target RGB color (rgb_input) will be at this index in the colormap.
% We place it roughly in the middle.
idx_pivot = floor(N/2) + 1;

% --- Initialize colormap in HSV space ---
cmap_hsv = zeros(N, 3);

% --- Generate first part: White to Target Color ---
% This part will have idx_pivot colors, interpolating from
% hsv_white_equiv to hsv_target.
s_path1 = linspace(hsv_white_equiv(2), S_target, idx_pivot);
v_path1 = linspace(hsv_white_equiv(3), V_target, idx_pivot);

cmap_hsv(1:idx_pivot, 1) = H_target;      % Constant Hue
cmap_hsv(1:idx_pivot, 2) = s_path1';    % Interpolated Saturation
cmap_hsv(1:idx_pivot, 3) = v_path1';    % Interpolated Value

% --- Generate second part: Target Color to Black ---
% This part will have (N - idx_pivot + 1) colors.
% It starts from hsv_target (which is cmap_hsv(idx_pivot,:))
% and interpolates to hsv_black_equiv.
num_points_part2 = N - idx_pivot + 1;

s_path2 = linspace(S_target, hsv_black_equiv(2), num_points_part2);
v_path2 = linspace(V_target, hsv_black_equiv(3), num_points_part2);

cmap_hsv(idx_pivot:N, 1) = H_target;      % Constant Hue
cmap_hsv(idx_pivot:N, 2) = s_path2';    % Interpolated Saturation
cmap_hsv(idx_pivot:N, 3) = v_path2';    % Interpolated Value

% --- Convert full HSV colormap to RGB ---
cmap = hsv2rgb(cmap_hsv);

% --- Ensure pure white at start and pure black at end ---
% This corrects any minor deviations from pure white/black that might occur
% due to HSV->RGB conversion, especially when S=0.
cmap(1,:) = [1, 1, 1]; % Pure white
cmap(N,:) = [0, 0, 0]; % Pure black

% Ensure the pivot color is exactly the input RGB.
% This is important if rgb_input was, for example, a specific named color
% or already slightly desaturated, to avoid drift from hsv->rgb conversion.
% (Only if pivot is not the first or last element, which is guaranteed by N>=3)
if idx_pivot > 1 && idx_pivot < N
    cmap(idx_pivot,:) = rgb_input;
end

end