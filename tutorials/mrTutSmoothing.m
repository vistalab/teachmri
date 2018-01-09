
img = randn([256,256]);
imagesc(img); colormap(gray);
 
kernel = mkgausskernel([32,32],[3,3]);
figure ; imagesc(kernel); colormap(gray);
surf(kernel)

smoothImage = convolution(img,kernel);
figure; imagesc(smoothImage); colormap(gray);

