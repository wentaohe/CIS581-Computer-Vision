function videoCreation(morphed_im)

video = VideoWriter('Carving.avi');

for i=1:size(morphed_im)
    open(video);
    frame=uint8(morphed_im{i});
    writeVideo(video,frame);
end

close(video);

implay ('Carving.avi');
end