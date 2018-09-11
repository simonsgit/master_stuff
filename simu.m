function [t,y] = simu(trange,naxons,activn)

    [U_y_init,U_ordering,U_params,activ_params] = MRG_init(0,naxons);
    t = zeros(numel(trange),1);
    y = zeros(numel(trange),numel(U_y_init));
    U_y = reshape(U_y_init,[1,numel(U_y_init)]);
    for n = trange
        dU_dydt = MRG_diff(n,U_y,U_params,activ_params,naxons,0,activn).*trange(2);
        U_y = U_y + reshape(dU_dydt,[1,numel(dU_dydt)]);
        y(trange == n,1:end) = U_y;
        solve y1 in
    end