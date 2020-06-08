function h = drawfreehand(varargin)
%drawfreehand Create draggable, reshapable freehand ROI
%    H = drawfreehand begins interactive placement of a freehand region of
%    interest (ROI) on the current axes. The function returns H, a handle to
%    an images.roi.Freehand object. You can modify an ROI interactively
%    using the mouse. The ROI also supports a context menu that controls
%    aspects of its appearance and behavior.
%
%    H = drawfreehand(AX,____) creates the ROI in the axes specified by AX
%    instead of the current axes (gca).
%
%    H = drawfreehand(____, Name, Value) modifies the appearance of the ROI
%    using one or more name-value pairs.
%
%    During interactive placement, click and drag to draw the freehand
%    shape. After the shape has been drawn, you can click on the waypoints
%    to reshape the ROI. To add new waypoints to the ROI, use the context
%    menu or double-click the edge of the ROI. To remove waypoints,
%    right-click on the waypoint and select "Remove Waypoint" from the
%    context menu.
%
%    Parameters include:
%
%
%    'Closed'          Set the geometry of the freehand ROI, specified as
%                      true (default) or false. If true, DRAWFREEHAND draws
%                      a line to connect the point where you finish drawing
%                      with the point where you started drawing the ROI.
%                      If false, DRAWFREEHAND leaves the first and last
%                      points unconnected.
%
%    'Color'           ROI color, specified as a MATLAB ColorSpec. The
%                      intensities must be in the range [0,1].
%
%    'Deletable'       ROI can be interactively deleted via a context menu,
%                      specified as a logical scalar. When true (default),
%                      you can delete the ROI via the context menu. To
%                      disable this context menu item, set this property to
%                      false. Even when set to false, you can still delete
%                      the ROI by calling the delete function specifying the
%                      handle to the ROI, delete(H).
%
%    'DrawingArea'     Area of the axes in which you can interactively place
%                      the ROI, specified as one of these values:
%
%                      'auto'      - The drawing area is a superset of the 
%                                    current axes limits and a bounding box
%                                    that surrounds the ROI (default).
%                      'unlimited' - The drawing area has no boundary and
%                                    ROIs can be drawn or dragged to
%                                    extend beyond the axes limits.
%                      [x,y,w,h]   - The drawing area is restricted to an
%                                    area beginning at (x,y), with
%                                    width w and height h.
%
%    'FaceAlpha'       Transparency of ROI face, specified as a scalar
%                      value in the range [0 1]. When set to 1, the ROI is
%                      fully opaque. When set to 0, the ROI is completely
%                      transparent. Default value is 0.2.
%
%    'FaceSelectable'  Ability of the ROI face to capture clicks, specified
%                      as true or false. When true (default), you can
%                      select the ROI face. When false, you cannot select
%                      the ROI face by clicking.
%
%    'HandleVisibility'   Visibility of the ROI handle in the Children
%                         property of the parent, specified as one of these
%                         values:
%                         'on'      - Object handle is always visible
%                                     (default).
%                         'off'     - Object handle is never visible.
%                         'callback'- Object handle is visible from within
%                                     callbacks or functions invoked by
%                                     callbacks, but not from within
%                                     functions invoked from the command
%                                     line.
%
%    'InteractionsAllowed' Interactivity of the ROI, specified as one of
%                          these values:
%                          'all'      - ROI is fully interactable (default).
%                          'none'     - ROI is not interactable and no drag
%                                       points are visible.
%                          'reshape'  - ROI can be reshaped.
%                          'translate'- ROI can be translated (moved)
%                                       within the drawing area, but not
%                                       reshaped.
%
%    'Label'           ROI label, specified as a character vector or string.
%                      When this property is empty, no label is
%                      displayed (default).
%
%    'LabelVisible'    Visibility of the label, specified as one of these 
%                      values:
%                      'on'      - Label is visible when the ROI is visible
%                                  and the Label property is nonempty 
%                                  (default).
%                      'hover'   - Label is visible only when the mouse is
%                                  hovering over the ROI.
%                      'off'     - Label is not visible.
%
%    'LineWidth'       Line width, specified as a positive value in points.
%                      The default value is three times the number of points
%                      per screen pixel.
%
%    'Multiclick'      ROI drawing style during interactive placement,
%                      specified as true or false (default). When false, a
%                      single click and drag gesture completes the ROI.
%                      When true, you can combine multiple clicks while
%                      dragging with straight edges to make a more complex
%                      freehand shape.
%
%    'Parent'          ROI parent, specified as an axes object. A UIAxes
%                      cannot be the parent of an ROI.
%
%    'Position'        Position of the ROI, specified as an n-by-2 array
%                      of the form, [x1 y1; ...; xn yn] where each row
%                      specifies the position of a vertex of the ROI.
%
%    'Selected'        Selection state of the ROI, specified as true or
%                      false. To set this property to true interactively,
%                      click the ROI. To clear the selection of the ROI,
%                      and set this property to false, ctrl-click the ROI.
%
%    'SelectedColor'   Color of the ROI when the Selected property is true,
%                      specified as a MATLAB ColorSpec. The intensities must
%                      be in the range [0,1]. If you specify the value
%                      'none', the Color property specifies the ROI color,
%                      irrespective of the value of the Selected property.
%
%    'Smoothing'       Standard deviation of the smoothing kernel used to
%                      filter the ROI, specified as numeric scalar.
%                      DRAWFREEHAND uses a Gaussian smoothing kernel to
%                      filter the x- and y-coordinates of the freehand
%                      ROI after interactive placement. By default, the
%                      standard deviation is 1. The filter size is defined
%                      as 2*ceil(2*Smoothing) + 1.
%
%    'StripeColor'     Color of the ROI stripe, specified as a MATLAB
%                      ColorSpec. By default, the edge of an ROI is solid
%                      colored. If you specify a StripeColor, the ROI edge
%                      is striped, using a combination of the Color value
%                      and this value. The intensities must be in the range
%                      [0,1].
%
%    'Tag'             Tag to associate with the ROI, specified as a
%                      character vector or string.
%
%    'UIContextMenu'   Context menu, specified as a ContextMenu object. Use
%                      this property to display a custom context menu when
%                      you right-click on the ROI. Create the context menu
%                      using the uicontextmenu function.
%
%    'UserData'        Data to associate with the ROI, specified as any
%                      MATLAB data, for example, a scalar, vector,
%                      matrix, cell array, string, character array, table,
%                      or structure. MATLAB does not use this data.
%
%    'Visible'         ROI visibility, specified as one of these values:
%
%                      'on'  - Display the ROI (default).
%                      'off' - Hide the ROI without deleting it. You
%                              still can access the properties of an
%                              invisible ROI.
%
%    'Waypoints'       Placement of waypoints, specified as an n-by-1
%                      logical array where each row is either true or false.
%                      Where the Waypoints array is true, DRAWFREEHAND
%                      places a waypoint at the position specified by the
%                      corresponding row of the Position property. The
%                      Waypoint array must be the same length as the
%                      Position property. If you interactively drag a
%                      waypoint, you modify the ROI between the specified
%                      waypoint and its immediate neighboring waypoints.
%                      If you specify an empty array, DRAWFREEHAND generates
%                      the Waypoints array automatically at locations of
%                      increased curvature.
%
%    Example 1
%    ---------
%
%    % Display an image
%    figure;
%    imshow(imread('baby.jpg'));
%
%    % Begin interactive placement of a freehand
%    h = drawfreehand();
%
%    % Fill in the freehand face but prevent it from being clickable
%    h.FaceAlpha = 1;
%    h.FaceSelectable = false;
%
%
%    See also:  images.roi.Freehand, drawassisted, drawcircle, drawellipse,
%    drawline, drawpoint, drawpolygon, drawpolyline, drawrectangle,
%    drawcuboid

% Copyright 2018 The MathWorks, Inc.

% Create ROI using formal interface
h = images.roi.Freehand(varargin{:});

if isempty(h.Parent)
    h.Parent = gca;
end

% If ROI was not fully defined, start interactive drawing
if isempty(h.Position)
    figure(ancestor(h,'figure'))
    h.draw;
end
