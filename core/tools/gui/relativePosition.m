% Benjamin Hershberg, 2020
%
% Usage: 
%   position = relativePosition( parent, row, col, dimensions )
%
% Description:
%   Translates standardized row / col grid coordinates to a Matlab graphics
%   Position vector in units of pixels. This greatly simplifies the
%   placement and arrangement of UI elements.
%
%
% parent: the UI element you want to place something in (e.g. a tab)
% row: row index(es) to place at starting from row 1 at top
% col: col index(es) to place at starting from col 1 at left
% dimensions: over-ride the default grid pitch with a [px py pw ph] vector
%
% Ex1: relativePosition(tabPointer, 1, 1)
%   Returns the position vector that fills a standard rectangle area
%   spanning from normalized row x-coordinate 1 to 2 and normalized 
%   column y-coordinate 1 to 2 on the grid.
%
% Ex2: relativePosition(tabPointer, [1 2], [1 2])
%   Same behavior as Ex1. above.
%
% Ex3: relativePosition(tabPointer, [1.2 4.4], [3.3 4.5])
%   Returns the position vector that fills the fractional grid coordinates
%   from x-coordinates 1.2 to 4.4 and y-coordinates 3.3 to 4.5
%
function position = relativePosition( parent, row, col, dimensions )

    px = 0;
    py = 0;
    pw = 0;
    ph = 0;
    initializeGraphics;

    if(nargin < 4)
        d = [px, py, pw, ph];
    else 
        d = dimensions;
    end

    pParent = getpixelposition(parent);
    topLeft = [0 pParent(4) 0 0];

    if(length(col) == 1)
        col = [col col+1];
    end
    horizSpan = max(col) - min(col);
    
    if(length(row) == 1)
        row = [row row+1];
    end
    vertSpan = max(row) - min(row);

    position(1) = d(1)+(min(col)-1)*(d(1)+d(3));
    position(2) = topLeft(2) - (min(row)+vertSpan-1)*(d(2)+d(4));
    position(3) = (horizSpan-1)*d(1)+horizSpan*d(3);
    position(4) = (vertSpan-1)*d(2) + vertSpan*d(4);

end