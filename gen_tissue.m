function gen_tissue(No, fdiam, adiam)
    fasc_diam = fdiam; % fascicle radius in um
    axon_diam = adiam; % axon radius in um
    axon_x = zeros(1,No);
    axon_y = zeros(1,No);
    axon_z = zeros(1,No);
    axon_rad = ones(1,No).* axon_diam/2;
    a = rand * 2 * pi;
    r = (fasc_diam/2 - axon_rad(1)) * sqrt(rand);
    axon_x(1) = r * cos(a);
    axon_y(1) = r * sin(a);
    axon_z(1) = 0;
    for n = 2:No
        overlaps = ones(1,n-1);
        while ismember(1,overlaps)
            a = rand * 2 * pi;
            r = (fasc_diam/2 - axon_rad(n)) * sqrt(rand);
            axon_x(n) = r * cos(a);
            axon_y(n) = r * sin(a);
            axon_z(n) = 0;
            for m = 1:n-1
                dx = axon_x(m) - axon_x(n);
                dy = axon_y(m) - axon_y(n);
                if dx^2 +dy^2 <= axon_diam
                    overlaps(1,m) = 1;
                    disp('overlap');
                else
                    overlaps(1,m) = 0;
                    disp('no overlap');
                end
  
            end
            
        end
    end
    string = '{%f';
    for n = 1:No
        string = strcat(string,', %f');
    end
    string = strcat(string, '};\n');
    disp(axon_x);
    fid = fopen( '/Users/st18/tissue.geo', 'wt');
    fprintf(fid, '// Axon Parameters\n');
    fprintf(fid, 'No = %f;\n',No);
    fprintf(fid, 'axon_msh = 0.1;\n');
    fprintf(fid, strcat('axon_x[] = ', string) , 0, axon_x);
    fprintf(fid, strcat('axon_y[] = ', string) , 0, axon_y);
    fprintf(fid, strcat('axon_z[] = ', string) , 0, axon_z);
    fprintf(fid, strcat('axon_rad[] = ',string) , 0, axon_rad);
    fprintf(fid, 'axon_h = %f;\n', 11.50);
    fprintf(fid, 'axon_lay = %f;\n', 11);
    fprintf(fid, ' \n');
    fprintf(fid, '//Electrode Parameters;\n');
    fprintf(fid, 'elec_xyz[] = {0, 1.75, axon_h/2};\n');
    fprintf(fid, 'elec_extr[] = {3, 0, 0};\n');
    fprintf(fid, 'elec_msh = 0.1;\n');
    fprintf(fid, 'elec_rad = 0.1;\n');
    fprintf(fid, 'elec_lay = 14;\n');
    fprintf(fid,' \n');
    fprintf(fid, '//Endoneurium Parameters\n');
    fprintf(fid, 'endo_xyz[] = {0, 0, 0};\n');
    fprintf(fid, 'endo_msh = 0.5;\n');
    fprintf(fid, 'endo_rad = %f;\n', fasc_diam/2);
    fclose(fid);
end