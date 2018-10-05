function gen_tissue(NoF, NoA, ndiam, fdiam, adiam)
    nerv_diam = ndiam; % nerve radius in um
    fasc_diam = fdiam; % fascicle radius in um
    axon_diam = adiam; % axon radius in um
    
    alpha = pi/4; % angle of electrode
    c = 0.1; % translation of electrode
    d = 1; % thickness of electrode
    
    fasc_x = zeros(1,NoF);
    fasc_y = zeros(1,NoF);
    fasc_z = zeros(1,NoF);
    fasc_rad = ones(1,NoF) .* fasc_diam/2;
    overlap = 1;
    while ismember(1,overlap)
        a = rand * 2 * pi;
        r = (nerv_diam/2 - fasc_rad(1)) * sqrt(rand);
        fasc_x(1) = r * cos(a);
        fasc_y(1) = r * sin(a);
        fasc_z(1) = 0;
        y = c + tan(alpha) *fasc_x(1);
        dy = fasc_y(1) - y;
        disp(((fasc_rad(1)+d)/cos(alpha))^2);
        if dy^2 < ((fasc_rad(1)+d)/cos(alpha))^2
            overlap = 1;
        else
            overlap = 0;
        end
    end    
    for n = 2:NoF
        overlaps = ones(1,n-1);
        while ismember(1,overlaps)
            a = rand * 2 * pi;
            r = (nerv_diam/2 - fasc_rad(n)) * sqrt(rand);
            fasc_x(n) = r * cos(a);
            fasc_y(n) = r * sin(a);
            fasc_z(n) = 0;
            for m = 1:n-1
                dx = fasc_x(m) - fasc_x(n);
                dy = fasc_y(m) - fasc_y(n);
                y = c + tan(alpha) *fasc_x(1);
                dye = fasc_y(n) - y;
                if dx^2 +dy^2 <= fasc_diam^2
                    overlaps(1,m) = 1;
                    disp('overlap');
                elseif dye^2 < ((fasc_rad(n)+d)/cos(alpha))^2
                    overlaps(1,m) = 1;
                    disp('overlap');
                else
                    overlaps(1,m) = 0;
                    disp('no overlap');
                end
            end
        end
    end
    
    axon_x = zeros(1,NoA*NoF);
    axon_y = zeros(1,NoA*NoF);
    axon_z = zeros(1,NoA*NoF);
    axon_rad = ones(1,NoA*NoF) .* axon_diam/2;
    axon_h = 11.50;
    for m = 1:NoF
        disp(m);
        a = rand * 2 * pi;
        r = (fasc_diam/2 - axon_rad(1)) * sqrt(rand);
        axon_x((m-1)*NoA+1) = r * cos(a);
        axon_y((m-1)*NoA+1) = r * sin(a);
        axon_z((m-1)*NoA+1) = 0;

        for n = 2:NoA
            %disp('n = ' n);
            overlaps = ones(1,n-1);
            while ismember(1,overlaps)
                a = rand * 2 * pi;
                r = (fasc_diam/2 - axon_rad((m-1)*NoA+n)) * sqrt(rand);
                axon_x((m-1)*NoA+n) = r * cos(a);
                axon_y((m-1)*NoA+n) = r * sin(a);
                axon_z((m-1)*NoA+n) = 0;
                for o = 1:n-1
                    dx = axon_x((m-1)*NoA+o) - axon_x((m-1)*NoA+n);
                    dy = axon_y((m-1)*NoA+o) - axon_y((m-1)*NoA+n);
                    if dx^2 + dy^2 <= axon_diam^2
                        overlaps(1,o) = 1;
                        disp('overlap');
                    else
                        overlaps(1,o) = 0;
                        disp('no overlap');
                    end 
                end
            end
        end
    end
    
    fstring = '{%f';
    for n = 1:NoF
        fstring = strcat(fstring,', %f');
    end
    fstring = strcat(fstring, '};\n');
    
    astring = '{%f';
    for n = 1:NoA*NoF
        astring = strcat(astring,', %f');
    end
    
    estring = '{%f, %f, %f, %f, %f};\n';
    dxe = sin(alpha)*d;
    dye = cos(alpha)*d;
    elec_x = [0, -d, 0, d, 0];
    elec_y = [0, 0, 0, 0, 0];
    elec_z = [ axon_h/2, axon_h/2, axon_h/2+d, axon_h/2, axon_h/2-d];
    
    astring = strcat(astring, '};\n');
    disp(axon_x);
    fid = fopen( '/Users/st18/tissue.geo', 'wt');
    fprintf(fid, '// Fascicle Parameters\n');
    fprintf(fid, 'NoF = %f;\n',NoF);
    fprintf(fid, 'fasc_msh = 1;\n');
    fprintf(fid, strcat('fasc_x[] = ', fstring) , 0, fasc_x);
    fprintf(fid, strcat('fasc_y[] = ', fstring) , 0, fasc_y);
    fprintf(fid, strcat('fasc_z[] = ', fstring) , 0, fasc_z);
    fprintf(fid, strcat('fasc_rad[] = ',fstring) , 0, fasc_rad);
    fprintf(fid, ' \n');
    fprintf(fid, '// Axon Parameters\n');
    fprintf(fid, 'NoA = %f;\n',NoA);
    fprintf(fid, 'axon_msh = 0.1;\n');
    fprintf(fid, strcat('axon_x[] = ', astring) , 0, axon_x);
    fprintf(fid, strcat('axon_y[] = ', astring) , 0, axon_y);
    fprintf(fid, strcat('axon_z[] = ', astring) , 0, axon_z);
    fprintf(fid, strcat('axon_rad[] = ',astring) , 0, axon_rad);
    fprintf(fid, 'axon_h = %f;\n', axon_h);
    fprintf(fid, 'axon_lay = %f;\n', 11);
    fprintf(fid, ' \n');
    fprintf(fid, '//Electrode Parameters;\n');
    fprintf(fid, strcat('elec_x[] = ', estring) , elec_x);
    fprintf(fid, strcat('elec_y[] = ', estring) , elec_y);
    fprintf(fid, strcat('elec_z[] = ', estring) , elec_z);
    fprintf(fid, 'elec_extr[] = {%f, %f, 0};\n', dxe, dye);
    fprintf(fid, 'elec_msh = 0.1;\n');
    fprintf(fid, 'elec_rad = 0.1;\n');
    fprintf(fid, 'elec_lay = 14;\n');
    fprintf(fid,' \n');
    fprintf(fid, '//Endoneurium Parameters\n');
    fprintf(fid, 'endo_xyz[] = {0, 0, 0};\n');
    fprintf(fid, 'endo_msh = 0.5;\n');
    fprintf(fid, 'fasc_rad = %f;\n', fasc_diam/2);
    fclose(fid);
end