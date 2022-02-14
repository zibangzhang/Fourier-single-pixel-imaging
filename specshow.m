function specshow(spec)
	% imagesc(log(abs(spec)+1).^(3/2)); axis image;
    imagesc(log(abs(spec)+1).^(1/3)); axis image;
end