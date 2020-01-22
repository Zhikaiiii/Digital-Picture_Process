function evenfilter = generate_gabor(sigma,orientation,wavelength)
%����ָ���������Ͳ�����ż�Գ�Gabor�˲���
    sigma_x = sigma;
    sigma_y = sigma;
    radius = sigma_x*3;
    [x,y] = meshgrid(-radius:radius);
    evenfilter  = exp(-(x.^2/sigma_x^2 + y.^2/sigma_y^2)/2).*cos(2*pi*(1/wavelength)*x);  
    evenfilter = imrotate(evenfilter, orientation, 'bilinear','crop');