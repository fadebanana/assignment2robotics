classdef loadply < handle
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        project
        %Ply file data
        faceData;
        vertexData;
        data;
   
    end
    methods
        %Load the object by trisurf
        function self = loadply(file_name, location)
            [self.faceData, self.vertexData,self.data] = plyread(file_name, 'tri');    
            vertexColours = [self.data.vertex.red, self.data.vertex.green, self.data.vertex.blue] / 255;
            for zOffset = location(3,4)
             for yOffset = location(2,4)
                 for xOffset = location(1,4)
                     trisurf(self.faceData,self.vertexData(:,1) + xOffset,self.vertexData(:,2) + yOffset, self.vertexData(:,3) + zOffset ...
                 ,'FaceVertexCData',vertexColours,'EdgeColor','interp','EdgeLighting','flat');
                 end
             end
            end
       hold on;
        drawnow();
        end
   
        
    end
end


