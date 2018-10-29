function [U_y_init,U_ordering,U_params,activ_params,flux_params,intracom_params] = MRG_init(t,naxons)
    [U_axon, U_ordering, U_params] = AxonNode_Compart_init(t);
    
    if naxons > 1
        add_axon = horzcat(repmat([0;-80;0;0;0;0],1,10),U_axon);
        U_y_init = horzcat(U_axon,repmat(add_axon,1,naxons-1));
        
        % calculate flux parameters
        xc_n = 0;
        xc_in = 1e-9 / 240;
        xc = [xc_n;xc_in;xc_in;xc_in;xc_in;xc_in;xc_in;xc_in;xc_in;xc_in;xc_in;xc_n;xc_in];
        %xraxial_n = 7e5 / (pi*((((3.3/2)+0.002)^2)-((3.3/2)^2)));
        %xraxial_m = 7e5 / (pi*((((3.3/2)+0.002)^2)-((3.3/2)^2)));
        %xraxial_f = 7e5 / (pi*((((6.9/2)+0.004)^2)-((6.9/2)^2)));
        %xraxial_s = 7e5 / (pi*((((6.9/2)+0.004)^2)-((6.9/2)^2)));
        %xraxial = [xraxial_n;xraxial_m;xraxial_f;xraxial_s;xraxial_s;xraxial_s;xraxial_s;xraxial_s;xraxial_s;xraxial_f;xraxial_m;xraxial_n;xraxial_m];
        d_n = 3.3; % diameter at Ranvier node and MYSA compartment
        d_p = 6.9; % diameter at FLUT and STIN compartment
        d_i = 10; % diameter of fiber
        d = [d_n;d_i;d_i;d_i;d_i;d_i;d_i;d_i;d_i;d_i;d_i;d_n;d_i];
        de = d + [0.004;0.004;0.008;0.008;0.008;0.008;0.008;0.008;0.008;0.008;0.004;0.004;0.004]; 
        Ra_n = 7e5;
        Ra_m = 7e5 * (d_i/d_n)^2;
        Ra_f = 7e5 * (d_i/d_p)^2;
        Ra_s = 7e5 * (d_i/d_p)^2;
        Ra = [Ra_n;Ra_m;Ra_f;Ra_s;Ra_s;Ra_s;Ra_s;Ra_s;Ra_s;Ra_f;Ra_m;Ra_n;Ra_m];
        l_n = 1; % length of Ranvier node
        l_m = 3; % length of MYSA compartment
        l_f = 46; % length of FLUT compartment
        deltax = 1150; % internodal distance
        l_s = (deltax-l_n-(2*l_m)-(2*l_f))/6; % length of STIN compartment
        l = [l_n;l_m;l_f;l_s;l_s;l_s;l_s;l_s;l_s;l_f;l_m;l_n;l_m];
        c_n = 2e-8;
        c_m = 2e-8 * (d_n/d_i);
        c_f = 2e-8 * (d_p/d_i);
        c_s = 2e-8 * (d_p/d_i);
        cm = [c_n;c_m;c_f;c_s;c_s;c_s;c_s;c_s;c_s;c_f;c_m;c_n;c_m];
        cmxc = cm + xc;
        itaus = 1e-3.*(2*l).^2 .*Ra .*cm./d;
        itaus = vertcat(itaus, repmat(itaus(3:end),naxons-2,1));
        %itaus = repmat((1e-3.*(2*l).^2 .*Ra .*de .* ce.*cm)./(d.*(d.*cm+de.*ce)),naxons-1,1);
        etaus1 = 1e-3.*(2*l).^2 .*Ra .*cmxc./d;
        etaus1 = vertcat(etaus1,repmat(etaus1(3:end),naxons-2,1));
        etaus2 = (1e-3.*(2*l).^2 .*Ra_n .*cmxc.*de)./(de.^2-d.^2);
        etaus2 = vertcat(etaus2,repmat(etaus2(3:end),naxons-2,1));
        flux_params = struct();
        flux_params.int_taus = vertcat((itaus(1)+itaus(2))./2, (itaus(2:end) + itaus(1:end-1))./2);
        flux_params.ext_taus1 = vertcat((etaus1(1)+etaus1(2))./2, (etaus1(2:end) + etaus1(1:end-1))./2);
        flux_params.ext_taus2 = vertcat((etaus2(1)+etaus2(2))./2, (etaus2(2:end) + etaus2(1:end-1))./2);
        
        % calculate intracompartment parameters
        gpas_m = d_n/d_i;
        gpas_f = 0.1 * d_n/d_i;
        gpas_s = 0.1 * d_n/d_i;
        gpas = [gpas_m;gpas_f;gpas_s;gpas_s;gpas_s;gpas_s;gpas_s;gpas_s;gpas_f;gpas_m];
        intracom_params = struct();
        intracom_params.ext = (1/240) ./ (cm(2:end-2) .* 2e8 + (0.1/240)); 
        intracom_params.int = gpas ./ (cm(2:end-2) .* 2e8);
    else
        U_y_init = U_axon;
        flux_params = 0;
    end
    % set activation parameters
    activ_params = struct();
    Cm = 2;
    activ_params.Cm = Cm;
    g_L = 7;
    activ_params.g_L = g_L;
    offset = 50;
    activ_params.offset = offset;
    bcl = 1000;
    activ_params.bcl = bcl;
    duration = 0.1;
    activ_params.n = 1;
    activ_params.duration = duration;
    strength = 2000;
    activ_params.strength = strength;
    
end