for i = 1:size(xaxis)
    b = size(xaxis);
        x1 = xaxis(i,1);
        y1 = yaxis(i,1);
    if i < b(1,1)
        location = eye(4)*transl(xaxis(i,1),yaxis(i,1),-0.292)*trotx(pi/2);
        x2 = xaxis((i+1),1);
        y2 = yaxis((i+1),1);
        plot3([x1 x2],[y1 y2],[-0.398 -0.398],'color','r');
        movement.move2unknowlocation(robot,location);
    end
    if i == b(1,1)
        location1 = eye(4)*transl(xaxis(1,1),yaxis(1,1),-0.292)*trotx(pi/2);         %return 2 start point
        x3 = xaxis(1,1);
        y3 = yaxis(1,1);
        plot3([x1 x3],[y1 y3],[-0.398 -0.398],'color','r');
        movement.move2unknowlocation(robot,location1);
    end


end