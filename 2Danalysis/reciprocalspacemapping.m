function [DATA, Npnt] = reciprocalspacemapping(DATA, Npnt, qx, qy, qz, img, qbox)
    qxmin = qbox.qxmin;
    qymin = qbox.qymin;
    qzmin = qbox.qzmin;
    deltaq = qbox.deltaq;
    qxN = qbox.qxN;
    qyN = qbox.qyN;
    qzN = qbox.qzN;
    t = isnan(qx) | isnan(qy) | isnan(qz);
    qx(t) = []; qy(t) = []; qz(t) = []; img(t) = [];
    
    qxI = fix((qx-qxmin)/deltaq);
    qyI = fix((qy-qymin)/deltaq);
    qzI = fix((qz-qzmin)/deltaq);
    qxI2 = fix((-qx-qxmin)/deltaq);
    qyI2 = fix((-qy-qymin)/deltaq);
    qzI2 = fix((-qz-qzmin)/deltaq);
    t = qxI>qxN | qxI < 1 | qyI > qyN | qyI < 1 | qzI > qzN | qzI < 1;
    t =  t | qxI2>qxN | qxI2 < 1 | qyI2 > qyN | qyI2 < 1 | qzI2 > qzN | qzI2 < 1; 
    t = t | ~isreal(qzI);
    t = t | ~isreal(qzI2);
    img(t) = [];
    qxI(t) = [];
    qyI(t) = [];
    qzI(t) = [];
    qxI2(t) = [];
    qyI2(t) = [];
    qzI2(t) = [];
    for k = 1:numel(img)
        DATA(qxI(k), qyI(k), qzI(k)) = DATA(qxI(k), qyI(k), qzI(k)) + img(k);
        DATA(qxI2(k), qyI2(k), qzI2(k)) = DATA(qxI2(k), qyI2(k), qzI2(k)) + img(k);
        Npnt(qxI(k), qyI(k), qzI(k)) = Npnt(qxI(k), qyI(k), qzI(k)) + 1;
        Npnt(qxI2(k), qyI2(k), qzI2(k)) = Npnt(qxI2(k), qyI2(k), qzI2(k)) + 1;
    end
