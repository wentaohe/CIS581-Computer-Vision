function [x, y] = border_detector(img, x, y)
    x_max = size(img, 2);
    y_max = size(img, 1);

    index = (x < 21);
    x(index) = [];
    y(index) = [];

    index = abs(x_max * ones(size(x, 1), 1) - x) < 19;
    x(index) = [];
    y(index) = [];

    index = (y < 21);
    x(index) = [];
    y(index) = [];

    index = abs(y_max * ones(size(y, 1), 1) - y) < 19;
    x(index) = [];
    y(index) = [];
end