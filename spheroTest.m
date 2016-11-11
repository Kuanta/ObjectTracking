if ~exist('sph','var')
    
    sph = sphero();
    connect(sph);
    result = ping(sph);
    if ~result, 
        disp('Example aborted due to unsuccessful ping');
        return, 
    else  sph.Color='r';
        sph
    end
    