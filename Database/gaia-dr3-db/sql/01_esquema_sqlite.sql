-- Esquema Gaia DR3 v1 para SQLite (arreglos guardados como texto JSON, booleanos como 0/1).
-- Generado por scripts/02_generar_esquema.py

-- [Catálogo principal] gaia_source — acceso: TAP (ADQL)
CREATE TABLE IF NOT EXISTS gaia_source (
    solution_id INTEGER,
    designation TEXT,
    source_id INTEGER,
    random_index INTEGER,
    ref_epoch REAL,
    ra REAL,
    ra_error REAL,
    dec REAL,
    dec_error REAL,
    parallax REAL,
    parallax_error REAL,
    parallax_over_error REAL,
    pm REAL,
    pmra REAL,
    pmra_error REAL,
    pmdec REAL,
    pmdec_error REAL,
    ra_dec_corr REAL,
    ra_parallax_corr REAL,
    ra_pmra_corr REAL,
    ra_pmdec_corr REAL,
    dec_parallax_corr REAL,
    dec_pmra_corr REAL,
    dec_pmdec_corr REAL,
    parallax_pmra_corr REAL,
    parallax_pmdec_corr REAL,
    pmra_pmdec_corr REAL,
    astrometric_n_obs_al INTEGER,
    astrometric_n_obs_ac INTEGER,
    astrometric_n_good_obs_al INTEGER,
    astrometric_n_bad_obs_al INTEGER,
    astrometric_gof_al REAL,
    astrometric_chi2_al REAL,
    astrometric_excess_noise REAL,
    astrometric_excess_noise_sig REAL,
    astrometric_params_solved INTEGER,
    astrometric_primary_flag INTEGER,
    nu_eff_used_in_astrometry REAL,
    pseudocolour REAL,
    pseudocolour_error REAL,
    ra_pseudocolour_corr REAL,
    dec_pseudocolour_corr REAL,
    parallax_pseudocolour_corr REAL,
    pmra_pseudocolour_corr REAL,
    pmdec_pseudocolour_corr REAL,
    astrometric_matched_transits INTEGER,
    visibility_periods_used INTEGER,
    astrometric_sigma5d_max REAL,
    matched_transits INTEGER,
    new_matched_transits INTEGER,
    matched_transits_removed INTEGER,
    ipd_gof_harmonic_amplitude REAL,
    ipd_gof_harmonic_phase REAL,
    ipd_frac_multi_peak INTEGER,
    ipd_frac_odd_win INTEGER,
    ruwe REAL,
    scan_direction_strength_k1 REAL,
    scan_direction_strength_k2 REAL,
    scan_direction_strength_k3 REAL,
    scan_direction_strength_k4 REAL,
    scan_direction_mean_k1 REAL,
    scan_direction_mean_k2 REAL,
    scan_direction_mean_k3 REAL,
    scan_direction_mean_k4 REAL,
    duplicated_source INTEGER,
    phot_g_n_obs INTEGER,
    phot_g_mean_flux REAL,
    phot_g_mean_flux_error REAL,
    phot_g_mean_flux_over_error REAL,
    phot_g_mean_mag REAL,
    phot_bp_n_obs INTEGER,
    phot_bp_mean_flux REAL,
    phot_bp_mean_flux_error REAL,
    phot_bp_mean_flux_over_error REAL,
    phot_bp_mean_mag REAL,
    phot_rp_n_obs INTEGER,
    phot_rp_mean_flux REAL,
    phot_rp_mean_flux_error REAL,
    phot_rp_mean_flux_over_error REAL,
    phot_rp_mean_mag REAL,
    phot_bp_rp_excess_factor REAL,
    phot_bp_n_contaminated_transits INTEGER,
    phot_bp_n_blended_transits INTEGER,
    phot_rp_n_contaminated_transits INTEGER,
    phot_rp_n_blended_transits INTEGER,
    phot_proc_mode INTEGER,
    bp_rp REAL,
    bp_g REAL,
    g_rp REAL,
    radial_velocity REAL,
    radial_velocity_error REAL,
    rv_method_used INTEGER,
    rv_nb_transits INTEGER,
    rv_nb_deblended_transits INTEGER,
    rv_visibility_periods_used INTEGER,
    rv_expected_sig_to_noise REAL,
    rv_renormalised_gof REAL,
    rv_chisq_pvalue REAL,
    rv_time_duration REAL,
    rv_amplitude_robust REAL,
    rv_template_teff REAL,
    rv_template_logg REAL,
    rv_template_fe_h REAL,
    rv_atm_param_origin INTEGER,
    vbroad REAL,
    vbroad_error REAL,
    vbroad_nb_transits INTEGER,
    grvs_mag REAL,
    grvs_mag_error REAL,
    grvs_mag_nb_transits INTEGER,
    rvs_spec_sig_to_noise REAL,
    phot_variable_flag TEXT,
    l REAL,
    b REAL,
    ecl_lon REAL,
    ecl_lat REAL,
    in_qso_candidates INTEGER,
    in_galaxy_candidates INTEGER,
    non_single_star INTEGER,
    has_xp_continuous INTEGER,
    has_xp_sampled INTEGER,
    has_rvs INTEGER,
    has_epoch_photometry INTEGER,
    has_epoch_rv INTEGER,
    has_mcmc_gspphot INTEGER,
    has_mcmc_msc INTEGER,
    in_andromeda_survey INTEGER,
    classprob_dsc_combmod_quasar REAL,
    classprob_dsc_combmod_galaxy REAL,
    classprob_dsc_combmod_star REAL,
    teff_gspphot REAL,
    teff_gspphot_lower REAL,
    teff_gspphot_upper REAL,
    logg_gspphot REAL,
    logg_gspphot_lower REAL,
    logg_gspphot_upper REAL,
    mh_gspphot REAL,
    mh_gspphot_lower REAL,
    mh_gspphot_upper REAL,
    distance_gspphot REAL,
    distance_gspphot_lower REAL,
    distance_gspphot_upper REAL,
    azero_gspphot REAL,
    azero_gspphot_lower REAL,
    azero_gspphot_upper REAL,
    ag_gspphot REAL,
    ag_gspphot_lower REAL,
    ag_gspphot_upper REAL,
    ebpminrp_gspphot REAL,
    ebpminrp_gspphot_lower REAL,
    ebpminrp_gspphot_upper REAL,
    libname_gspphot TEXT
);
CREATE INDEX IF NOT EXISTS gaia_source_source_id_idx ON gaia_source (source_id);

-- [Catálogo principal] gaia_source_lite — acceso: TAP (ADQL)
CREATE TABLE IF NOT EXISTS gaia_source_lite (
    source_id INTEGER,
    random_index INTEGER,
    ra REAL,
    dec REAL,
    parallax REAL,
    parallax_error REAL,
    parallax_over_error REAL,
    pmra REAL,
    pmra_error REAL,
    pmdec REAL,
    pmdec_error REAL,
    astrometric_params_solved INTEGER,
    pseudocolour REAL,
    pseudocolour_error REAL,
    ipd_frac_multi_peak INTEGER,
    ipd_frac_odd_win INTEGER,
    ruwe REAL,
    phot_g_mean_flux_over_error REAL,
    phot_g_mean_mag REAL,
    phot_bp_mean_flux_over_error REAL,
    phot_bp_mean_mag REAL,
    phot_rp_mean_flux_over_error REAL,
    phot_rp_mean_mag REAL,
    phot_bp_rp_excess_factor REAL,
    bp_rp REAL,
    radial_velocity REAL,
    radial_velocity_error REAL,
    rv_nb_transits INTEGER,
    rv_expected_sig_to_noise REAL,
    rv_renormalised_gof REAL,
    rv_chisq_pvalue REAL,
    phot_variable_flag TEXT,
    l REAL,
    b REAL,
    in_qso_candidates INTEGER,
    in_galaxy_candidates INTEGER,
    non_single_star INTEGER,
    has_xp_continuous INTEGER,
    has_xp_sampled INTEGER,
    has_rvs INTEGER,
    has_epoch_photometry INTEGER,
    has_epoch_rv INTEGER,
    has_mcmc_gspphot INTEGER,
    has_mcmc_msc INTEGER,
    in_andromeda_survey INTEGER,
    teff_gspphot REAL,
    logg_gspphot REAL,
    mh_gspphot REAL,
    distance_gspphot REAL,
    ag_gspphot REAL,
    ebpminrp_gspphot REAL
);
CREATE INDEX IF NOT EXISTS gaia_source_lite_source_id_idx ON gaia_source_lite (source_id);

-- [Parámetros astrofísicos] astrophysical_parameters — acceso: TAP (ADQL)
CREATE TABLE IF NOT EXISTS astrophysical_parameters (
    solution_id INTEGER,
    source_id INTEGER,
    classprob_dsc_combmod_quasar REAL,
    classprob_dsc_combmod_galaxy REAL,
    classprob_dsc_combmod_star REAL,
    classprob_dsc_combmod_whitedwarf REAL,
    classprob_dsc_combmod_binarystar REAL,
    classprob_dsc_specmod_quasar REAL,
    classprob_dsc_specmod_galaxy REAL,
    classprob_dsc_specmod_star REAL,
    classprob_dsc_specmod_whitedwarf REAL,
    classprob_dsc_specmod_binarystar REAL,
    classprob_dsc_allosmod_quasar REAL,
    classprob_dsc_allosmod_galaxy REAL,
    classprob_dsc_allosmod_star REAL,
    teff_gspphot REAL,
    teff_gspphot_lower REAL,
    teff_gspphot_upper REAL,
    logg_gspphot REAL,
    logg_gspphot_lower REAL,
    logg_gspphot_upper REAL,
    mh_gspphot REAL,
    mh_gspphot_lower REAL,
    mh_gspphot_upper REAL,
    distance_gspphot REAL,
    distance_gspphot_lower REAL,
    distance_gspphot_upper REAL,
    azero_gspphot REAL,
    azero_gspphot_lower REAL,
    azero_gspphot_upper REAL,
    ag_gspphot REAL,
    ag_gspphot_lower REAL,
    ag_gspphot_upper REAL,
    abp_gspphot REAL,
    abp_gspphot_lower REAL,
    abp_gspphot_upper REAL,
    arp_gspphot REAL,
    arp_gspphot_lower REAL,
    arp_gspphot_upper REAL,
    ebpminrp_gspphot REAL,
    ebpminrp_gspphot_lower REAL,
    ebpminrp_gspphot_upper REAL,
    mg_gspphot REAL,
    mg_gspphot_lower REAL,
    mg_gspphot_upper REAL,
    radius_gspphot REAL,
    radius_gspphot_lower REAL,
    radius_gspphot_upper REAL,
    logposterior_gspphot REAL,
    mcmcaccept_gspphot REAL,
    libname_gspphot TEXT,
    teff_gspspec REAL,
    teff_gspspec_lower REAL,
    teff_gspspec_upper REAL,
    logg_gspspec REAL,
    logg_gspspec_lower REAL,
    logg_gspspec_upper REAL,
    mh_gspspec REAL,
    mh_gspspec_lower REAL,
    mh_gspspec_upper REAL,
    alphafe_gspspec REAL,
    alphafe_gspspec_lower REAL,
    alphafe_gspspec_upper REAL,
    fem_gspspec REAL,
    fem_gspspec_lower REAL,
    fem_gspspec_upper REAL,
    fem_gspspec_nlines INTEGER,
    fem_gspspec_linescatter REAL,
    sife_gspspec REAL,
    sife_gspspec_lower REAL,
    sife_gspspec_upper REAL,
    sife_gspspec_nlines INTEGER,
    sife_gspspec_linescatter REAL,
    cafe_gspspec REAL,
    cafe_gspspec_lower REAL,
    cafe_gspspec_upper REAL,
    cafe_gspspec_nlines INTEGER,
    cafe_gspspec_linescatter REAL,
    tife_gspspec REAL,
    tife_gspspec_lower REAL,
    tife_gspspec_upper REAL,
    tife_gspspec_nlines INTEGER,
    tife_gspspec_linescatter REAL,
    mgfe_gspspec REAL,
    mgfe_gspspec_lower REAL,
    mgfe_gspspec_upper REAL,
    mgfe_gspspec_nlines INTEGER,
    mgfe_gspspec_linescatter REAL,
    ndfe_gspspec REAL,
    ndfe_gspspec_lower REAL,
    ndfe_gspspec_upper REAL,
    ndfe_gspspec_nlines INTEGER,
    ndfe_gspspec_linescatter REAL,
    feiim_gspspec REAL,
    feiim_gspspec_lower REAL,
    feiim_gspspec_upper REAL,
    feiim_gspspec_nlines INTEGER,
    feiim_gspspec_linescatter REAL,
    sfe_gspspec REAL,
    sfe_gspspec_lower REAL,
    sfe_gspspec_upper REAL,
    sfe_gspspec_nlines INTEGER,
    sfe_gspspec_linescatter REAL,
    zrfe_gspspec REAL,
    zrfe_gspspec_lower REAL,
    zrfe_gspspec_upper REAL,
    zrfe_gspspec_nlines INTEGER,
    zrfe_gspspec_linescatter REAL,
    nfe_gspspec REAL,
    nfe_gspspec_lower REAL,
    nfe_gspspec_upper REAL,
    nfe_gspspec_nlines INTEGER,
    nfe_gspspec_linescatter REAL,
    crfe_gspspec REAL,
    crfe_gspspec_lower REAL,
    crfe_gspspec_upper REAL,
    crfe_gspspec_nlines INTEGER,
    crfe_gspspec_linescatter REAL,
    cefe_gspspec REAL,
    cefe_gspspec_lower REAL,
    cefe_gspspec_upper REAL,
    cefe_gspspec_nlines INTEGER,
    cefe_gspspec_linescatter REAL,
    nife_gspspec REAL,
    nife_gspspec_lower REAL,
    nife_gspspec_upper REAL,
    nife_gspspec_nlines INTEGER,
    nife_gspspec_linescatter REAL,
    cn0ew_gspspec REAL,
    cn0ew_gspspec_uncertainty REAL,
    cn0_gspspec_centralline REAL,
    cn0_gspspec_width REAL,
    dib_gspspec_lambda REAL,
    dib_gspspec_lambda_uncertainty REAL,
    dibew_gspspec REAL,
    dibew_gspspec_uncertainty REAL,
    dibewnoise_gspspec_uncertainty REAL,
    dibp0_gspspec REAL,
    dibp2_gspspec REAL,
    dibp2_gspspec_uncertainty REAL,
    dibqf_gspspec INTEGER,
    flags_gspspec TEXT,
    logchisq_gspspec REAL,
    ew_espels_halpha REAL,
    ew_espels_halpha_uncertainty REAL,
    ew_espels_halpha_flag TEXT,
    ew_espels_halpha_model REAL,
    classlabel_espels TEXT,
    classlabel_espels_flag TEXT,
    classprob_espels_wcstar REAL,
    classprob_espels_wnstar REAL,
    classprob_espels_bestar REAL,
    classprob_espels_ttauristar REAL,
    classprob_espels_herbigstar REAL,
    classprob_espels_dmestar REAL,
    classprob_espels_pne REAL,
    azero_esphs REAL,
    azero_esphs_uncertainty REAL,
    ag_esphs REAL,
    ag_esphs_uncertainty REAL,
    ebpminrp_esphs REAL,
    ebpminrp_esphs_uncertainty REAL,
    teff_esphs REAL,
    teff_esphs_uncertainty REAL,
    logg_esphs REAL,
    logg_esphs_uncertainty REAL,
    vsini_esphs REAL,
    vsini_esphs_uncertainty REAL,
    flags_esphs TEXT,
    spectraltype_esphs TEXT,
    activityindex_espcs REAL,
    activityindex_espcs_uncertainty REAL,
    activityindex_espcs_input TEXT,
    teff_espucd REAL,
    teff_espucd_uncertainty REAL,
    flags_espucd TEXT,
    radius_flame REAL,
    radius_flame_lower REAL,
    radius_flame_upper REAL,
    lum_flame REAL,
    lum_flame_lower REAL,
    lum_flame_upper REAL,
    mass_flame REAL,
    mass_flame_lower REAL,
    mass_flame_upper REAL,
    age_flame REAL,
    age_flame_lower REAL,
    age_flame_upper REAL,
    flags_flame TEXT,
    evolstage_flame INTEGER,
    gravredshift_flame REAL,
    gravredshift_flame_lower REAL,
    gravredshift_flame_upper REAL,
    bc_flame REAL,
    mh_msc REAL,
    mh_msc_upper REAL,
    mh_msc_lower REAL,
    azero_msc REAL,
    azero_msc_upper REAL,
    azero_msc_lower REAL,
    distance_msc REAL,
    distance_msc_upper REAL,
    distance_msc_lower REAL,
    teff_msc1 REAL,
    teff_msc1_upper REAL,
    teff_msc1_lower REAL,
    teff_msc2 REAL,
    teff_msc2_upper REAL,
    teff_msc2_lower REAL,
    logg_msc1 REAL,
    logg_msc1_upper REAL,
    logg_msc1_lower REAL,
    logg_msc2 REAL,
    logg_msc2_upper REAL,
    logg_msc2_lower REAL,
    ag_msc REAL,
    ag_msc_upper REAL,
    ag_msc_lower REAL,
    logposterior_msc REAL,
    mcmcaccept_msc REAL,
    mcmcdrift_msc REAL,
    flags_msc TEXT,
    neuron_oa_id INTEGER,
    neuron_oa_dist REAL,
    neuron_oa_dist_percentile_rank INTEGER,
    flags_oa TEXT
);
CREATE INDEX IF NOT EXISTS astrophysical_parameters_source_id_idx ON astrophysical_parameters (source_id);

-- [Parámetros astrofísicos] astrophysical_parameters_supp — acceso: TAP (ADQL)
CREATE TABLE IF NOT EXISTS astrophysical_parameters_supp (
    solution_id INTEGER,
    source_id INTEGER,
    libname_best_gspphot TEXT,
    teff_gspphot_marcs REAL,
    teff_gspphot_marcs_lower REAL,
    teff_gspphot_marcs_upper REAL,
    logg_gspphot_marcs REAL,
    logg_gspphot_marcs_lower REAL,
    logg_gspphot_marcs_upper REAL,
    mh_gspphot_marcs REAL,
    mh_gspphot_marcs_lower REAL,
    mh_gspphot_marcs_upper REAL,
    distance_gspphot_marcs REAL,
    distance_gspphot_marcs_lower REAL,
    distance_gspphot_marcs_upper REAL,
    azero_gspphot_marcs REAL,
    azero_gspphot_marcs_lower REAL,
    azero_gspphot_marcs_upper REAL,
    ag_gspphot_marcs REAL,
    ag_gspphot_marcs_lower REAL,
    ag_gspphot_marcs_upper REAL,
    abp_gspphot_marcs REAL,
    abp_gspphot_marcs_lower REAL,
    abp_gspphot_marcs_upper REAL,
    arp_gspphot_marcs REAL,
    arp_gspphot_marcs_lower REAL,
    arp_gspphot_marcs_upper REAL,
    ebpminrp_gspphot_marcs REAL,
    ebpminrp_gspphot_marcs_lower REAL,
    ebpminrp_gspphot_marcs_upper REAL,
    mg_gspphot_marcs REAL,
    mg_gspphot_marcs_lower REAL,
    mg_gspphot_marcs_upper REAL,
    radius_gspphot_marcs REAL,
    radius_gspphot_marcs_lower REAL,
    radius_gspphot_marcs_upper REAL,
    logposterior_gspphot_marcs REAL,
    mcmcaccept_gspphot_marcs REAL,
    teff_gspphot_phoenix REAL,
    teff_gspphot_phoenix_lower REAL,
    teff_gspphot_phoenix_upper REAL,
    logg_gspphot_phoenix REAL,
    logg_gspphot_phoenix_lower REAL,
    logg_gspphot_phoenix_upper REAL,
    mh_gspphot_phoenix REAL,
    mh_gspphot_phoenix_lower REAL,
    mh_gspphot_phoenix_upper REAL,
    distance_gspphot_phoenix REAL,
    distance_gspphot_phoenix_lower REAL,
    distance_gspphot_phoenix_upper REAL,
    azero_gspphot_phoenix REAL,
    azero_gspphot_phoenix_lower REAL,
    azero_gspphot_phoenix_upper REAL,
    ag_gspphot_phoenix REAL,
    ag_gspphot_phoenix_lower REAL,
    ag_gspphot_phoenix_upper REAL,
    abp_gspphot_phoenix REAL,
    abp_gspphot_phoenix_lower REAL,
    abp_gspphot_phoenix_upper REAL,
    arp_gspphot_phoenix REAL,
    arp_gspphot_phoenix_lower REAL,
    arp_gspphot_phoenix_upper REAL,
    ebpminrp_gspphot_phoenix REAL,
    ebpminrp_gspphot_phoenix_lower REAL,
    ebpminrp_gspphot_phoenix_upper REAL,
    mg_gspphot_phoenix REAL,
    mg_gspphot_phoenix_lower REAL,
    mg_gspphot_phoenix_upper REAL,
    radius_gspphot_phoenix REAL,
    radius_gspphot_phoenix_lower REAL,
    radius_gspphot_phoenix_upper REAL,
    logposterior_gspphot_phoenix REAL,
    mcmcaccept_gspphot_phoenix REAL,
    teff_gspphot_ob REAL,
    teff_gspphot_ob_lower REAL,
    teff_gspphot_ob_upper REAL,
    logg_gspphot_ob REAL,
    logg_gspphot_ob_lower REAL,
    logg_gspphot_ob_upper REAL,
    mh_gspphot_ob REAL,
    mh_gspphot_ob_lower REAL,
    mh_gspphot_ob_upper REAL,
    distance_gspphot_ob REAL,
    distance_gspphot_ob_lower REAL,
    distance_gspphot_ob_upper REAL,
    azero_gspphot_ob REAL,
    azero_gspphot_ob_lower REAL,
    azero_gspphot_ob_upper REAL,
    ag_gspphot_ob REAL,
    ag_gspphot_ob_lower REAL,
    ag_gspphot_ob_upper REAL,
    abp_gspphot_ob REAL,
    abp_gspphot_ob_lower REAL,
    abp_gspphot_ob_upper REAL,
    arp_gspphot_ob REAL,
    arp_gspphot_ob_lower REAL,
    arp_gspphot_ob_upper REAL,
    ebpminrp_gspphot_ob REAL,
    ebpminrp_gspphot_ob_lower REAL,
    ebpminrp_gspphot_ob_upper REAL,
    mg_gspphot_ob REAL,
    mg_gspphot_ob_lower REAL,
    mg_gspphot_ob_upper REAL,
    radius_gspphot_ob REAL,
    radius_gspphot_ob_lower REAL,
    radius_gspphot_ob_upper REAL,
    logposterior_gspphot_ob REAL,
    mcmcaccept_gspphot_ob REAL,
    teff_gspphot_a REAL,
    teff_gspphot_a_lower REAL,
    teff_gspphot_a_upper REAL,
    logg_gspphot_a REAL,
    logg_gspphot_a_lower REAL,
    logg_gspphot_a_upper REAL,
    mh_gspphot_a REAL,
    mh_gspphot_a_lower REAL,
    mh_gspphot_a_upper REAL,
    distance_gspphot_a REAL,
    distance_gspphot_a_lower REAL,
    distance_gspphot_a_upper REAL,
    azero_gspphot_a REAL,
    azero_gspphot_a_lower REAL,
    azero_gspphot_a_upper REAL,
    ag_gspphot_a REAL,
    ag_gspphot_a_lower REAL,
    ag_gspphot_a_upper REAL,
    abp_gspphot_a REAL,
    abp_gspphot_a_lower REAL,
    abp_gspphot_a_upper REAL,
    arp_gspphot_a REAL,
    arp_gspphot_a_lower REAL,
    arp_gspphot_a_upper REAL,
    ebpminrp_gspphot_a REAL,
    ebpminrp_gspphot_a_lower REAL,
    ebpminrp_gspphot_a_upper REAL,
    mg_gspphot_a REAL,
    mg_gspphot_a_lower REAL,
    mg_gspphot_a_upper REAL,
    radius_gspphot_a REAL,
    radius_gspphot_a_lower REAL,
    radius_gspphot_a_upper REAL,
    logposterior_gspphot_a REAL,
    mcmcaccept_gspphot_a REAL,
    teff_gspspec_ann REAL,
    teff_gspspec_ann_lower REAL,
    teff_gspspec_ann_upper REAL,
    logg_gspspec_ann REAL,
    logg_gspspec_ann_lower REAL,
    logg_gspspec_ann_upper REAL,
    mh_gspspec_ann REAL,
    mh_gspspec_ann_lower REAL,
    mh_gspspec_ann_upper REAL,
    alphafe_gspspec_ann REAL,
    alphafe_gspspec_ann_lower REAL,
    alphafe_gspspec_ann_upper REAL,
    logchisq_gspspec_ann REAL,
    flags_gspspec_ann TEXT,
    radius_flame_spec REAL,
    radius_flame_spec_lower REAL,
    radius_flame_spec_upper REAL,
    lum_flame_spec REAL,
    lum_flame_spec_lower REAL,
    lum_flame_spec_upper REAL,
    mass_flame_spec REAL,
    mass_flame_spec_lower REAL,
    mass_flame_spec_upper REAL,
    age_flame_spec REAL,
    age_flame_spec_lower REAL,
    age_flame_spec_upper REAL,
    flags_flame_spec TEXT,
    evolstage_flame_spec INTEGER,
    gravredshift_flame_spec REAL,
    gravredshift_flame_spec_lower REAL,
    gravredshift_flame_spec_upper REAL,
    bc_flame_spec REAL
);
CREATE INDEX IF NOT EXISTS astrophysical_parameters_supp_source_id_idx ON astrophysical_parameters_supp (source_id);

-- [Parámetros astrofísicos] mcmc_samples_gsp_phot — acceso: DataLink (MCMC_GSPPHOT)
CREATE TABLE IF NOT EXISTS mcmc_samples_gsp_phot (
    solution_id INTEGER,
    source_id INTEGER,
    nsamples INTEGER,
    teff TEXT,
    azero TEXT,
    logg TEXT,
    mh TEXT,
    ag TEXT,
    mg TEXT,
    distancepc TEXT,
    abp TEXT,
    arp TEXT,
    ebpminrp TEXT,
    log_pos TEXT,
    log_lik TEXT,
    radius TEXT
);
CREATE INDEX IF NOT EXISTS mcmc_samples_gsp_phot_source_id_idx ON mcmc_samples_gsp_phot (source_id);

-- [Parámetros astrofísicos] mcmc_samples_msc — acceso: DataLink (MCMC_MSC)
CREATE TABLE IF NOT EXISTS mcmc_samples_msc (
    source_id INTEGER,
    solution_id INTEGER,
    nsamples INTEGER,
    teff1 TEXT,
    teff2 TEXT,
    logg1 TEXT,
    logg2 TEXT,
    azero TEXT,
    mh TEXT,
    distancepc TEXT,
    log_pos TEXT,
    log_lik TEXT
);
CREATE INDEX IF NOT EXISTS mcmc_samples_msc_source_id_idx ON mcmc_samples_msc (source_id);

-- [Parámetros astrofísicos] oa_neuron_information — acceso: TAP (ADQL)
CREATE TABLE IF NOT EXISTS oa_neuron_information (
    solution_id INTEGER,
    som_id INTEGER,
    neuron_id INTEGER,
    neuron_row_index INTEGER,
    neuron_column_index INTEGER,
    hits INTEGER,
    class_label TEXT,
    centroid_id INTEGER,
    centroid_distance REAL,
    template_distance REAL,
    g_mag_mean REAL,
    g_mag_std_dev REAL,
    g_mag_min REAL,
    g_mag_max REAL,
    bp_mag_mean REAL,
    bp_mag_std_dev REAL,
    bp_mag_min REAL,
    bp_mag_max REAL,
    rp_mag_mean REAL,
    rp_mag_std_dev REAL,
    rp_mag_min REAL,
    rp_mag_max REAL,
    pm_ra_mean REAL,
    pm_ra_std_dev REAL,
    pm_ra_min REAL,
    pm_ra_max REAL,
    pm_dec_mean REAL,
    pm_dec_std_dev REAL,
    pm_dec_min REAL,
    pm_dec_max REAL,
    parallax_mean REAL,
    parallax_std_dev REAL,
    parallax_min REAL,
    parallax_max REAL,
    gal_latitude_mean REAL,
    gal_latitude_std_dev REAL,
    gal_latitude_min REAL,
    gal_latitude_max REAL,
    intra_neuron_distance_mean REAL,
    intra_neuron_distance_std_dev REAL,
    intra_neuron_distance_min REAL,
    intra_neuron_distance_max REAL,
    inter_neuron_distance_mean REAL,
    inter_neuron_distance_std_dev REAL,
    inter_neuron_distance_min REAL,
    inter_neuron_distance_max REAL,
    template_name TEXT,
    distance_percentile25 REAL,
    distance_percentile50 REAL,
    distance_percentile68 REAL,
    distance_percentile75 REAL,
    distance_percentile95 REAL,
    distance_fwhm REAL,
    distance_skew REAL,
    distance_kurtosis REAL,
    distance_i_q_r REAL,
    distance_fwhm_norm REAL,
    quality_category INTEGER,
    bp_transits_mean REAL,
    bp_transits_std_dev REAL,
    bp_transits_min REAL,
    bp_transits_max REAL,
    rp_transits_mean REAL,
    rp_transits_std_dev REAL,
    rp_transits_min REAL,
    rp_transits_max REAL,
    ruwe_mean REAL,
    ruwe_std_dev REAL,
    ruwe_min REAL,
    ruwe_max REAL,
    bprp_mean_flux_excess_mean REAL,
    bprp_mean_flux_excess_std_dev REAL,
    bprp_mean_flux_excess_min REAL,
    bprp_mean_flux_excess_max REAL,
    bprp_colour_mean REAL,
    bprp_colour_std_dev REAL,
    bprp_colour_min REAL,
    bprp_colour_max REAL
);

-- [Parámetros astrofísicos] oa_neuron_xp_spectra — acceso: TAP (ADQL)
CREATE TABLE IF NOT EXISTS oa_neuron_xp_spectra (
    solution_id INTEGER,
    neuron_id INTEGER,
    neuron_row_index INTEGER,
    neuron_column_index INTEGER,
    xp_spectrum_prototype_flux REAL,
    xp_spectrum_prototype_wavelength REAL,
    xp_spectrum_template_flux REAL
);

-- [Parámetros astrofísicos] total_galactic_extinction_map — acceso: TAP (ADQL)
CREATE TABLE IF NOT EXISTS total_galactic_extinction_map (
    solution_id INTEGER,
    healpix_id INTEGER,
    healpix_level INTEGER,
    a0 REAL,
    a0_uncertainty REAL,
    a0_min REAL,
    a0_max REAL,
    num_tracers_used INTEGER,
    optimum_hpx_flag INTEGER,
    status INTEGER
);

-- [Parámetros astrofísicos] total_galactic_extinction_map_opt — acceso: TAP (ADQL)
CREATE TABLE IF NOT EXISTS total_galactic_extinction_map_opt (
    solution_id INTEGER,
    healpix_id INTEGER,
    a0 REAL,
    a0_uncertainty REAL,
    num_tracers_used INTEGER,
    status INTEGER,
    optimum_hpx_level INTEGER
);

-- [Cruce con catálogos externos] allwise_best_neighbour — acceso: TAP (ADQL)
CREATE TABLE IF NOT EXISTS allwise_best_neighbour (
    source_id INTEGER,
    original_ext_source_id TEXT,
    angular_distance REAL,
    xm_flag INTEGER,
    allwise_oid INTEGER,
    number_of_neighbours INTEGER,
    number_of_mates INTEGER
);
CREATE INDEX IF NOT EXISTS allwise_best_neighbour_source_id_idx ON allwise_best_neighbour (source_id);

-- [Cruce con catálogos externos] allwise_neighbourhood — acceso: TAP (ADQL)
CREATE TABLE IF NOT EXISTS allwise_neighbourhood (
    source_id INTEGER,
    original_ext_source_id TEXT,
    angular_distance REAL,
    score REAL,
    xm_flag INTEGER,
    allwise_oid INTEGER
);
CREATE INDEX IF NOT EXISTS allwise_neighbourhood_source_id_idx ON allwise_neighbourhood (source_id);

-- [Cruce con catálogos externos] apassdr9_best_neighbour — acceso: TAP (ADQL)
CREATE TABLE IF NOT EXISTS apassdr9_best_neighbour (
    source_id INTEGER,
    clean_apassdr9_oid INTEGER,
    original_ext_source_id INTEGER,
    angular_distance REAL,
    number_of_neighbours INTEGER,
    number_of_mates INTEGER,
    xm_flag INTEGER
);
CREATE INDEX IF NOT EXISTS apassdr9_best_neighbour_source_id_idx ON apassdr9_best_neighbour (source_id);

-- [Cruce con catálogos externos] apassdr9_join — acceso: TAP (ADQL)
CREATE TABLE IF NOT EXISTS apassdr9_join (
    original_ext_source_id INTEGER,
    clean_apassdr9_oid INTEGER
);

-- [Cruce con catálogos externos] apassdr9_neighbourhood — acceso: TAP (ADQL)
CREATE TABLE IF NOT EXISTS apassdr9_neighbourhood (
    source_id INTEGER,
    clean_apassdr9_oid INTEGER,
    original_ext_source_id INTEGER,
    angular_distance REAL,
    score REAL,
    xm_flag INTEGER
);
CREATE INDEX IF NOT EXISTS apassdr9_neighbourhood_source_id_idx ON apassdr9_neighbourhood (source_id);

-- [Cruce con catálogos externos] dr2_neighbourhood — acceso: TAP (ADQL)
CREATE TABLE IF NOT EXISTS dr2_neighbourhood (
    dr2_source_id INTEGER,
    dr3_source_id INTEGER,
    angular_distance REAL,
    magnitude_difference REAL,
    proper_motion_propagation INTEGER
);

-- [Cruce con catálogos externos] gsc23_best_neighbour — acceso: TAP (ADQL)
CREATE TABLE IF NOT EXISTS gsc23_best_neighbour (
    source_id INTEGER,
    original_ext_source_id TEXT,
    angular_distance REAL,
    xm_flag INTEGER,
    clean_gsc23_oid INTEGER,
    number_of_neighbours INTEGER,
    number_of_mates INTEGER
);
CREATE INDEX IF NOT EXISTS gsc23_best_neighbour_source_id_idx ON gsc23_best_neighbour (source_id);

-- [Cruce con catálogos externos] gsc23_join — acceso: TAP (ADQL)
CREATE TABLE IF NOT EXISTS gsc23_join (
    original_ext_source_id TEXT,
    clean_gsc23_oid INTEGER
);

-- [Cruce con catálogos externos] gsc23_neighbourhood — acceso: TAP (ADQL)
CREATE TABLE IF NOT EXISTS gsc23_neighbourhood (
    source_id INTEGER,
    original_ext_source_id TEXT,
    angular_distance REAL,
    score REAL,
    xm_flag INTEGER,
    clean_gsc23_oid INTEGER
);
CREATE INDEX IF NOT EXISTS gsc23_neighbourhood_source_id_idx ON gsc23_neighbourhood (source_id);

-- [Cruce con catálogos externos] hipparcos2_best_neighbour — acceso: TAP (ADQL)
CREATE TABLE IF NOT EXISTS hipparcos2_best_neighbour (
    source_id INTEGER,
    original_ext_source_id INTEGER,
    angular_distance REAL,
    number_of_neighbours INTEGER,
    xm_flag INTEGER
);
CREATE INDEX IF NOT EXISTS hipparcos2_best_neighbour_source_id_idx ON hipparcos2_best_neighbour (source_id);

-- [Cruce con catálogos externos] hipparcos2_neighbourhood — acceso: TAP (ADQL)
CREATE TABLE IF NOT EXISTS hipparcos2_neighbourhood (
    source_id INTEGER,
    original_ext_source_id INTEGER,
    angular_distance REAL,
    score REAL,
    xm_flag INTEGER
);
CREATE INDEX IF NOT EXISTS hipparcos2_neighbourhood_source_id_idx ON hipparcos2_neighbourhood (source_id);

-- [Cruce con catálogos externos] panstarrs1_best_neighbour — acceso: TAP (ADQL)
CREATE TABLE IF NOT EXISTS panstarrs1_best_neighbour (
    source_id INTEGER,
    clean_panstarrs1_oid INTEGER,
    original_ext_source_id INTEGER,
    angular_distance REAL,
    number_of_neighbours INTEGER,
    number_of_mates INTEGER,
    xm_flag INTEGER
);
CREATE INDEX IF NOT EXISTS panstarrs1_best_neighbour_source_id_idx ON panstarrs1_best_neighbour (source_id);

-- [Cruce con catálogos externos] panstarrs1_join — acceso: TAP (ADQL)
CREATE TABLE IF NOT EXISTS panstarrs1_join (
    original_ext_source_id INTEGER,
    clean_panstarrs1_oid INTEGER
);

-- [Cruce con catálogos externos] panstarrs1_neighbourhood — acceso: TAP (ADQL)
CREATE TABLE IF NOT EXISTS panstarrs1_neighbourhood (
    source_id INTEGER,
    clean_panstarrs1_oid INTEGER,
    original_ext_source_id INTEGER,
    angular_distance REAL,
    score REAL,
    xm_flag INTEGER
);
CREATE INDEX IF NOT EXISTS panstarrs1_neighbourhood_source_id_idx ON panstarrs1_neighbourhood (source_id);

-- [Cruce con catálogos externos] ravedr5_best_neighbour — acceso: TAP (ADQL)
CREATE TABLE IF NOT EXISTS ravedr5_best_neighbour (
    source_id INTEGER,
    original_ext_source_id TEXT,
    angular_distance REAL,
    xm_flag INTEGER,
    clean_ravedr5_oid INTEGER,
    number_of_neighbours INTEGER
);
CREATE INDEX IF NOT EXISTS ravedr5_best_neighbour_source_id_idx ON ravedr5_best_neighbour (source_id);

-- [Cruce con catálogos externos] ravedr5_join — acceso: TAP (ADQL)
CREATE TABLE IF NOT EXISTS ravedr5_join (
    original_ext_source_id TEXT,
    clean_ravedr5_oid INTEGER
);

-- [Cruce con catálogos externos] ravedr5_neighbourhood — acceso: TAP (ADQL)
CREATE TABLE IF NOT EXISTS ravedr5_neighbourhood (
    source_id INTEGER,
    original_ext_source_id TEXT,
    angular_distance REAL,
    score REAL,
    xm_flag INTEGER,
    clean_ravedr5_oid INTEGER
);
CREATE INDEX IF NOT EXISTS ravedr5_neighbourhood_source_id_idx ON ravedr5_neighbourhood (source_id);

-- [Cruce con catálogos externos] ravedr6_best_neighbour — acceso: TAP (ADQL)
CREATE TABLE IF NOT EXISTS ravedr6_best_neighbour (
    source_id INTEGER,
    original_ext_source_id TEXT,
    angular_distance REAL,
    xm_flag INTEGER,
    ravedr6_oid INTEGER,
    number_of_neighbours INTEGER
);
CREATE INDEX IF NOT EXISTS ravedr6_best_neighbour_source_id_idx ON ravedr6_best_neighbour (source_id);

-- [Cruce con catálogos externos] ravedr6_join — acceso: TAP (ADQL)
CREATE TABLE IF NOT EXISTS ravedr6_join (
    original_ext_source_id TEXT,
    ravedr6_oid INTEGER
);

-- [Cruce con catálogos externos] ravedr6_neighbourhood — acceso: TAP (ADQL)
CREATE TABLE IF NOT EXISTS ravedr6_neighbourhood (
    source_id INTEGER,
    original_ext_source_id TEXT,
    angular_distance REAL,
    score REAL,
    xm_flag INTEGER,
    ravedr6_oid INTEGER
);
CREATE INDEX IF NOT EXISTS ravedr6_neighbourhood_source_id_idx ON ravedr6_neighbourhood (source_id);

-- [Cruce con catálogos externos] sdssdr13_best_neighbour — acceso: TAP (ADQL)
CREATE TABLE IF NOT EXISTS sdssdr13_best_neighbour (
    source_id INTEGER,
    clean_sdssdr13_oid INTEGER,
    original_ext_source_id INTEGER,
    angular_distance REAL,
    number_of_neighbours INTEGER,
    number_of_mates INTEGER,
    xm_flag INTEGER
);
CREATE INDEX IF NOT EXISTS sdssdr13_best_neighbour_source_id_idx ON sdssdr13_best_neighbour (source_id);

-- [Cruce con catálogos externos] sdssdr13_join — acceso: TAP (ADQL)
CREATE TABLE IF NOT EXISTS sdssdr13_join (
    original_ext_source_id INTEGER,
    clean_sdssdr13_oid INTEGER
);

-- [Cruce con catálogos externos] sdssdr13_neighbourhood — acceso: TAP (ADQL)
CREATE TABLE IF NOT EXISTS sdssdr13_neighbourhood (
    source_id INTEGER,
    clean_sdssdr13_oid INTEGER,
    original_ext_source_id INTEGER,
    angular_distance REAL,
    score REAL,
    xm_flag INTEGER
);
CREATE INDEX IF NOT EXISTS sdssdr13_neighbourhood_source_id_idx ON sdssdr13_neighbourhood (source_id);

-- [Cruce con catálogos externos] skymapperdr2_best_neighbour — acceso: TAP (ADQL)
CREATE TABLE IF NOT EXISTS skymapperdr2_best_neighbour (
    source_id INTEGER,
    original_ext_source_id INTEGER,
    angular_distance REAL,
    number_of_neighbours INTEGER,
    number_of_mates INTEGER,
    xm_flag INTEGER
);
CREATE INDEX IF NOT EXISTS skymapperdr2_best_neighbour_source_id_idx ON skymapperdr2_best_neighbour (source_id);

-- [Cruce con catálogos externos] skymapperdr2_join — acceso: TAP (ADQL)
CREATE TABLE IF NOT EXISTS skymapperdr2_join (
    original_ext_source_id INTEGER
);

-- [Cruce con catálogos externos] skymapperdr2_neighbourhood — acceso: TAP (ADQL)
CREATE TABLE IF NOT EXISTS skymapperdr2_neighbourhood (
    source_id INTEGER,
    original_ext_source_id INTEGER,
    angular_distance REAL,
    score REAL,
    xm_flag INTEGER
);
CREATE INDEX IF NOT EXISTS skymapperdr2_neighbourhood_source_id_idx ON skymapperdr2_neighbourhood (source_id);

-- [Cruce con catálogos externos] tmass_psc_xsc_best_neighbour — acceso: TAP (ADQL)
CREATE TABLE IF NOT EXISTS tmass_psc_xsc_best_neighbour (
    source_id INTEGER,
    original_ext_source_id TEXT,
    angular_distance REAL,
    xm_flag INTEGER,
    clean_tmass_psc_xsc_oid INTEGER,
    number_of_neighbours INTEGER,
    number_of_mates INTEGER
);
CREATE INDEX IF NOT EXISTS tmass_psc_xsc_best_neighbour_source_id_idx ON tmass_psc_xsc_best_neighbour (source_id);

-- [Cruce con catálogos externos] tmass_psc_xsc_join — acceso: TAP (ADQL)
CREATE TABLE IF NOT EXISTS tmass_psc_xsc_join (
    original_psc_source_id TEXT,
    original_xsc_source_id TEXT,
    clean_tmass_psc_xsc_oid INTEGER
);

-- [Cruce con catálogos externos] tmass_psc_xsc_neighbourhood — acceso: TAP (ADQL)
CREATE TABLE IF NOT EXISTS tmass_psc_xsc_neighbourhood (
    source_id INTEGER,
    original_ext_source_id TEXT,
    angular_distance REAL,
    score REAL,
    xm_flag INTEGER,
    clean_tmass_psc_xsc_oid INTEGER
);
CREATE INDEX IF NOT EXISTS tmass_psc_xsc_neighbourhood_source_id_idx ON tmass_psc_xsc_neighbourhood (source_id);

-- [Cruce con catálogos externos] tycho2tdsc_merge — acceso: TAP (ADQL)
CREATE TABLE IF NOT EXISTS tycho2tdsc_merge (
    id TEXT,
    hip INTEGER,
    tyc1 TEXT,
    tyc2 TEXT,
    tyc3 TEXT,
    id_tycho INTEGER,
    tyc TEXT,
    ra REAL,
    dec REAL,
    ra_deg REAL,
    de_deg REAL,
    ra_mdeg REAL,
    de_mdeg REAL,
    pm_ra REAL,
    pm_de REAL,
    ep_ra1990 REAL,
    ep_de1990 REAL,
    ep_ra_m REAL,
    ep_de_m REAL,
    num INTEGER,
    e_ra_deg REAL,
    e_de_deg REAL,
    corr REAL,
    e_ra_mdeg REAL,
    e_de_mdeg REAL,
    e_pm_ra REAL,
    e_pm_de REAL,
    q_ra_mdeg REAL,
    q_de_mdeg REAL,
    q_pm_de REAL,
    q_pm_ra REAL,
    pflag TEXT,
    posflg TEXT,
    ccdm TEXT,
    prox INTEGER,
    bt_mag REAL,
    vt_mag REAL,
    e_bt_mag REAL,
    e_vt_mag REAL,
    sys_no INTEGER,
    cmp TEXT,
    n_main INTEGER,
    n_sup INTEGER,
    magflg TEXT,
    wds TEXT,
    note TEXT,
    hd INTEGER,
    rcmp TEXT,
    pa REAL,
    sep REAL,
    e_pa REAL,
    e_pa_sep INTEGER,
    e_sep INTEGER
);

-- [Cruce con catálogos externos] tycho2tdsc_merge_best_neighbour — acceso: TAP (ADQL)
CREATE TABLE IF NOT EXISTS tycho2tdsc_merge_best_neighbour (
    source_id INTEGER,
    original_ext_source_id TEXT,
    angular_distance REAL,
    xm_flag INTEGER,
    tycho2tdsc_merge_oid INTEGER,
    number_of_neighbours INTEGER
);
CREATE INDEX IF NOT EXISTS tycho2tdsc_merge_best_neighbour_source_id_idx ON tycho2tdsc_merge_best_neighbour (source_id);

-- [Cruce con catálogos externos] tycho2tdsc_merge_neighbourhood — acceso: TAP (ADQL)
CREATE TABLE IF NOT EXISTS tycho2tdsc_merge_neighbourhood (
    source_id INTEGER,
    original_ext_source_id TEXT,
    angular_distance REAL,
    score REAL,
    xm_flag INTEGER,
    tycho2tdsc_merge_oid INTEGER
);
CREATE INDEX IF NOT EXISTS tycho2tdsc_merge_neighbourhood_source_id_idx ON tycho2tdsc_merge_neighbourhood (source_id);

-- [Cruce con catálogos externos] urat1_best_neighbour — acceso: TAP (ADQL)
CREATE TABLE IF NOT EXISTS urat1_best_neighbour (
    source_id INTEGER,
    original_ext_source_id TEXT,
    angular_distance REAL,
    xm_flag INTEGER,
    urat1_oid INTEGER,
    number_of_neighbours INTEGER,
    number_of_mates INTEGER
);
CREATE INDEX IF NOT EXISTS urat1_best_neighbour_source_id_idx ON urat1_best_neighbour (source_id);

-- [Cruce con catálogos externos] urat1_neighbourhood — acceso: TAP (ADQL)
CREATE TABLE IF NOT EXISTS urat1_neighbourhood (
    source_id INTEGER,
    original_ext_source_id TEXT,
    angular_distance REAL,
    score REAL,
    xm_flag INTEGER,
    urat1_oid INTEGER
);
CREATE INDEX IF NOT EXISTS urat1_neighbourhood_source_id_idx ON urat1_neighbourhood (source_id);

-- [Extragaláctico] galaxy_candidates — acceso: TAP (ADQL)
CREATE TABLE IF NOT EXISTS galaxy_candidates (
    solution_id INTEGER,
    source_id INTEGER,
    vari_best_class_name TEXT,
    vari_best_class_score REAL,
    classprob_dsc_combmod_galaxy REAL,
    classprob_dsc_combmod_quasar REAL,
    classlabel_dsc TEXT,
    classlabel_dsc_joint TEXT,
    classlabel_oa TEXT,
    redshift_ugc REAL,
    redshift_ugc_lower REAL,
    redshift_ugc_upper REAL,
    n_transits INTEGER,
    posangle_sersic REAL,
    posangle_sersic_error REAL,
    intensity_sersic REAL,
    intensity_sersic_error REAL,
    radius_sersic REAL,
    radius_sersic_error REAL,
    ellipticity_sersic REAL,
    ellipticity_sersic_error REAL,
    n_sersic REAL,
    n_sersic_error REAL,
    l2_sersic REAL,
    morph_params_corr_vec_sersic TEXT,
    flags_sersic INTEGER,
    posangle_de_vaucouleurs REAL,
    posangle_de_vaucouleurs_error REAL,
    intensity_de_vaucouleurs REAL,
    intensity_de_vaucouleurs_error REAL,
    radius_de_vaucouleurs REAL,
    radius_de_vaucouleurs_error REAL,
    ellipticity_de_vaucouleurs REAL,
    ellipticity_de_vaucouleurs_error REAL,
    l2_de_vaucouleurs REAL,
    morph_params_corr_vec_de_vaucouleurs TEXT,
    flags_de_vaucouleurs INTEGER,
    source_selection_flags INTEGER
);
CREATE INDEX IF NOT EXISTS galaxy_candidates_source_id_idx ON galaxy_candidates (source_id);

-- [Extragaláctico] galaxy_catalogue_name — acceso: TAP (ADQL)
CREATE TABLE IF NOT EXISTS galaxy_catalogue_name (
    solution_id INTEGER,
    source_id INTEGER,
    catalogue_id INTEGER
);
CREATE INDEX IF NOT EXISTS galaxy_catalogue_name_source_id_idx ON galaxy_catalogue_name (source_id);

-- [Extragaláctico] qso_candidates — acceso: TAP (ADQL)
CREATE TABLE IF NOT EXISTS qso_candidates (
    solution_id INTEGER,
    source_id INTEGER,
    astrometric_selection_flag INTEGER,
    gaia_crf_source INTEGER,
    vari_best_class_name TEXT,
    vari_best_class_score REAL,
    fractional_variability_g REAL,
    structure_function_index REAL,
    structure_function_index_scatter REAL,
    qso_variability REAL,
    non_qso_variability REAL,
    vari_agn_membership_score REAL,
    classprob_dsc_combmod_quasar REAL,
    classprob_dsc_combmod_galaxy REAL,
    classlabel_dsc TEXT,
    classlabel_dsc_joint TEXT,
    classlabel_oa TEXT,
    redshift_qsoc REAL,
    redshift_qsoc_lower REAL,
    redshift_qsoc_upper REAL,
    ccfratio_qsoc REAL,
    zscore_qsoc REAL,
    flags_qsoc INTEGER,
    n_transits INTEGER,
    intensity_quasar REAL,
    intensity_quasar_error REAL,
    intensity_hostgalaxy REAL,
    intensity_hostgalaxy_error REAL,
    radius_hostgalaxy REAL,
    radius_hostgalaxy_error REAL,
    sersic_index REAL,
    sersic_index_error REAL,
    ellipticity_hostgalaxy REAL,
    ellipticity_hostgalaxy_error REAL,
    posangle_hostgalaxy REAL,
    posangle_hostgalaxy_error REAL,
    host_galaxy_detected INTEGER,
    l2_norm REAL,
    morph_params_corr_vec TEXT,
    host_galaxy_flag INTEGER,
    source_selection_flags INTEGER
);
CREATE INDEX IF NOT EXISTS qso_candidates_source_id_idx ON qso_candidates (source_id);

-- [Extragaláctico] qso_catalogue_name — acceso: TAP (ADQL)
CREATE TABLE IF NOT EXISTS qso_catalogue_name (
    solution_id INTEGER,
    source_id INTEGER,
    catalogue_id INTEGER
);
CREATE INDEX IF NOT EXISTS qso_catalogue_name_source_id_idx ON qso_catalogue_name (source_id);

-- [Estrellas no simples (binarias)] nss_acceleration_astro — acceso: TAP (ADQL)
CREATE TABLE IF NOT EXISTS nss_acceleration_astro (
    solution_id INTEGER,
    source_id INTEGER,
    nss_solution_type TEXT,
    ra REAL,
    ra_error REAL,
    dec REAL,
    dec_error REAL,
    parallax REAL,
    parallax_error REAL,
    pmra REAL,
    pmra_error REAL,
    pmdec REAL,
    pmdec_error REAL,
    accel_ra REAL,
    accel_ra_error REAL,
    accel_dec REAL,
    accel_dec_error REAL,
    deriv_accel_ra REAL,
    deriv_accel_ra_error REAL,
    deriv_accel_dec REAL,
    deriv_accel_dec_error REAL,
    astrometric_n_obs_al INTEGER,
    astrometric_n_good_obs_al INTEGER,
    bit_index INTEGER,
    corr_vec TEXT,
    obj_func REAL,
    goodness_of_fit REAL,
    significance REAL,
    flags INTEGER
);
CREATE INDEX IF NOT EXISTS nss_acceleration_astro_source_id_idx ON nss_acceleration_astro (source_id);

-- [Estrellas no simples (binarias)] nss_non_linear_spectro — acceso: TAP (ADQL)
CREATE TABLE IF NOT EXISTS nss_non_linear_spectro (
    solution_id INTEGER,
    source_id INTEGER,
    nss_solution_type TEXT,
    mean_velocity REAL,
    mean_velocity_error REAL,
    first_deriv_velocity REAL,
    first_deriv_velocity_error REAL,
    second_deriv_velocity REAL,
    second_deriv_velocity_error REAL,
    rv_n_obs_primary INTEGER,
    rv_n_good_obs_primary INTEGER,
    bit_index INTEGER,
    corr_vec TEXT,
    obj_func REAL,
    goodness_of_fit REAL,
    flags INTEGER
);
CREATE INDEX IF NOT EXISTS nss_non_linear_spectro_source_id_idx ON nss_non_linear_spectro (source_id);

-- [Estrellas no simples (binarias)] nss_two_body_orbit — acceso: TAP (ADQL)
CREATE TABLE IF NOT EXISTS nss_two_body_orbit (
    solution_id INTEGER,
    source_id INTEGER,
    nss_solution_type TEXT,
    ra REAL,
    ra_error REAL,
    dec REAL,
    dec_error REAL,
    parallax REAL,
    parallax_error REAL,
    pmra REAL,
    pmra_error REAL,
    pmdec REAL,
    pmdec_error REAL,
    a_thiele_innes REAL,
    a_thiele_innes_error REAL,
    b_thiele_innes REAL,
    b_thiele_innes_error REAL,
    f_thiele_innes REAL,
    f_thiele_innes_error REAL,
    g_thiele_innes REAL,
    g_thiele_innes_error REAL,
    c_thiele_innes REAL,
    c_thiele_innes_error REAL,
    h_thiele_innes REAL,
    h_thiele_innes_error REAL,
    period REAL,
    period_error REAL,
    t_periastron REAL,
    t_periastron_error REAL,
    eccentricity REAL,
    eccentricity_error REAL,
    center_of_mass_velocity REAL,
    center_of_mass_velocity_error REAL,
    semi_amplitude_primary REAL,
    semi_amplitude_primary_error REAL,
    semi_amplitude_secondary REAL,
    semi_amplitude_secondary_error REAL,
    mass_ratio REAL,
    mass_ratio_error REAL,
    fill_factor_primary REAL,
    fill_factor_primary_error REAL,
    fill_factor_secondary REAL,
    fill_factor_secondary_error REAL,
    inclination REAL,
    inclination_error REAL,
    arg_periastron REAL,
    arg_periastron_error REAL,
    temperature_ratio REAL,
    temperature_ratio_error REAL,
    temperature_ratio_definition INTEGER,
    astrometric_n_obs_al INTEGER,
    astrometric_n_good_obs_al INTEGER,
    rv_n_obs_primary INTEGER,
    rv_n_good_obs_primary INTEGER,
    rv_n_obs_secondary INTEGER,
    rv_n_good_obs_secondary INTEGER,
    phot_g_n_obs INTEGER,
    phot_g_n_good_obs INTEGER,
    bit_index INTEGER,
    corr_vec TEXT,
    obj_func REAL,
    goodness_of_fit REAL,
    efficiency REAL,
    significance REAL,
    flags INTEGER,
    conf_spectro_period REAL,
    r_pole_sum REAL,
    r_l1_point_sum REAL,
    r_spher_sum REAL,
    ecl_time_primary REAL,
    ecl_time_secondary REAL,
    ecl_dur_primary REAL,
    ecl_dur_secondary REAL,
    g_luminosity_ratio REAL,
    input_period_error REAL,
    g_rank REAL,
    astrometric_jitter REAL
);
CREATE INDEX IF NOT EXISTS nss_two_body_orbit_source_id_idx ON nss_two_body_orbit (source_id);

-- [Estrellas no simples (binarias)] nss_vim_fl — acceso: TAP (ADQL)
CREATE TABLE IF NOT EXISTS nss_vim_fl (
    solution_id INTEGER,
    source_id INTEGER,
    nss_solution_type TEXT,
    ra REAL,
    ra_error REAL,
    dec REAL,
    dec_error REAL,
    parallax REAL,
    parallax_error REAL,
    pmra REAL,
    pmra_error REAL,
    pmdec REAL,
    pmdec_error REAL,
    ref_flux_g REAL,
    vim_d_ra REAL,
    vim_d_ra_error REAL,
    vim_d_dec REAL,
    vim_d_dec_error REAL,
    astrometric_n_obs_al INTEGER,
    astrometric_n_good_obs_al INTEGER,
    bit_index INTEGER,
    corr_vec TEXT,
    obj_func REAL,
    goodness_of_fit REAL,
    efficiency REAL,
    significance REAL,
    flags INTEGER
);
CREATE INDEX IF NOT EXISTS nss_vim_fl_source_id_idx ON nss_vim_fl (source_id);

-- [Verificación de rendimiento] binary_masses — acceso: TAP (ADQL)
CREATE TABLE IF NOT EXISTS binary_masses (
    source_id INTEGER,
    m1 REAL,
    m1_lower REAL,
    m1_upper REAL,
    m2 REAL,
    m2_lower REAL,
    m2_upper REAL,
    fluxratio REAL,
    fluxratio_lower REAL,
    fluxratio_upper REAL,
    combination_method TEXT,
    m1_ref TEXT,
    flag TEXT
);
CREATE INDEX IF NOT EXISTS binary_masses_source_id_idx ON binary_masses (source_id);

-- [Verificación de rendimiento] chemical_cartography — acceso: TAP (ADQL)
CREATE TABLE IF NOT EXISTS chemical_cartography (
    solution_id INTEGER,
    source_id INTEGER,
    jr_med REAL,
    jz_med REAL,
    jphi_med REAL,
    rplane_med REAL,
    vrplane_med REAL,
    vz_med REAL,
    vphi_med REAL,
    zmax_med REAL,
    rapo_med REAL,
    rperi_med REAL,
    ecc_med REAL,
    x_med REAL,
    y_med REAL,
    z_med REAL,
    energy_med REAL,
    jr_hi REAL,
    jz_hi REAL,
    jphi_hi REAL,
    rplane_hi REAL,
    vrplane_hi REAL,
    vz_hi REAL,
    vphi_hi REAL,
    zmax_hi REAL,
    rapo_hi REAL,
    rperi_hi REAL,
    ecc_hi REAL,
    x_hi REAL,
    y_hi REAL,
    z_hi REAL,
    jr_lo REAL,
    jz_lo REAL,
    jphi_lo REAL,
    rplane_lo REAL,
    vrplane_lo REAL,
    vz_lo REAL,
    vphi_lo REAL,
    zmax_lo REAL,
    rapo_lo REAL,
    rperi_lo REAL,
    ecc_lo REAL,
    x_lo REAL,
    y_lo REAL,
    z_lo REAL
);
CREATE INDEX IF NOT EXISTS chemical_cartography_source_id_idx ON chemical_cartography (source_id);

-- [Verificación de rendimiento] gold_sample_carbon_stars — acceso: TAP (ADQL)
CREATE TABLE IF NOT EXISTS gold_sample_carbon_stars (
    source_id INTEGER
);
CREATE INDEX IF NOT EXISTS gold_sample_carbon_stars_source_id_idx ON gold_sample_carbon_stars (source_id);

-- [Verificación de rendimiento] gold_sample_fgkm_stars — acceso: TAP (ADQL)
CREATE TABLE IF NOT EXISTS gold_sample_fgkm_stars (
    source_id INTEGER,
    teff_gspphot REAL,
    logg_gspphot REAL,
    mh_gspphot REAL,
    ag_gspphot REAL,
    ebpminrp_gspphot REAL,
    alphafe_gspspec REAL,
    teff_gspspec REAL,
    logg_gspspec REAL,
    mh_gspspec REAL,
    radius_flame REAL,
    lum_flame REAL,
    mass_flame REAL,
    age_flame REAL,
    evolstage_flame INTEGER,
    radius_flame_spec REAL,
    lum_flame_spec REAL,
    mass_flame_spec REAL,
    age_flame_spec REAL,
    evolstage_flame_spec INTEGER,
    spectraltype_esphs TEXT
);
CREATE INDEX IF NOT EXISTS gold_sample_fgkm_stars_source_id_idx ON gold_sample_fgkm_stars (source_id);

-- [Verificación de rendimiento] gold_sample_oba_stars — acceso: TAP (ADQL)
CREATE TABLE IF NOT EXISTS gold_sample_oba_stars (
    source_id INTEGER,
    vtan_flag INTEGER
);
CREATE INDEX IF NOT EXISTS gold_sample_oba_stars_source_id_idx ON gold_sample_oba_stars (source_id);

-- [Verificación de rendimiento] gold_sample_solar_analogues — acceso: TAP (ADQL)
CREATE TABLE IF NOT EXISTS gold_sample_solar_analogues (
    source_id INTEGER
);
CREATE INDEX IF NOT EXISTS gold_sample_solar_analogues_source_id_idx ON gold_sample_solar_analogues (source_id);

-- [Verificación de rendimiento] gold_sample_spss — acceso: TAP (ADQL)
CREATE TABLE IF NOT EXISTS gold_sample_spss (
    source_id INTEGER,
    spss_id INTEGER,
    spss_name TEXT,
    spectraltype TEXT,
    bin_flag INTEGER,
    var_flag INTEGER,
    teff REAL,
    teff_error REAL,
    logg REAL,
    logg_error REAL,
    feh REAL,
    feh_error REAL,
    alphafe REAL,
    alphafe_error REAL,
    radius REAL,
    radius_error REAL,
    lum REAL,
    lum_error REAL,
    mass REAL,
    mass_error REAL,
    age REAL,
    age_error REAL,
    azero REAL,
    azero_error REAL,
    ag REAL,
    ag_error REAL,
    ebpminrp REAL,
    ebpminrp_error REAL,
    distancepc REAL,
    distancepc_error REAL,
    radial_velocity REAL,
    radial_velocity_error REAL,
    vsini REAL,
    vsin_error REAL,
    notes TEXT
);
CREATE INDEX IF NOT EXISTS gold_sample_spss_source_id_idx ON gold_sample_spss (source_id);

-- [Verificación de rendimiento] gold_sample_ucd — acceso: TAP (ADQL)
CREATE TABLE IF NOT EXISTS gold_sample_ucd (
    source_id INTEGER,
    ftot_fobs REAL,
    lum REAL,
    lum_uncertainty REAL,
    radius REAL,
    radius_uncertainty REAL,
    reduced_chi2 REAL
);
CREATE INDEX IF NOT EXISTS gold_sample_ucd_source_id_idx ON gold_sample_ucd (source_id);

-- [Verificación de rendimiento] sso_orbits — acceso: TAP (ADQL)
CREATE TABLE IF NOT EXISTS sso_orbits (
    number_mp INTEGER,
    denomination TEXT,
    osc_epoch REAL,
    mean_anomaly REAL,
    arg_perihelion REAL,
    long_asc_node REAL,
    inclination REAL,
    eccentricity REAL,
    semi_major_axis REAL,
    orbital_elements_var_covar_matrix TEXT,
    std_dev_semi_major_axis REAL,
    h_state_vector TEXT,
    h_state_vector_var_covar_matrix TEXT,
    arc_length REAL,
    num_observations INTEGER
);

-- [Verificación de rendimiento] synthetic_photometry_gspc — acceso: TAP (ADQL)
CREATE TABLE IF NOT EXISTS synthetic_photometry_gspc (
    source_id INTEGER,
    c_star REAL,
    u_jkc_flux REAL,
    u_jkc_flux_error REAL,
    u_jkc_mag REAL,
    u_jkc_flag INTEGER,
    b_jkc_flux REAL,
    b_jkc_flux_error REAL,
    b_jkc_mag REAL,
    b_jkc_flag INTEGER,
    v_jkc_flux REAL,
    v_jkc_flux_error REAL,
    v_jkc_mag REAL,
    v_jkc_flag INTEGER,
    r_jkc_flux REAL,
    r_jkc_flux_error REAL,
    r_jkc_mag REAL,
    r_jkc_flag INTEGER,
    i_jkc_flux REAL,
    i_jkc_flux_error REAL,
    i_jkc_mag REAL,
    i_jkc_flag INTEGER,
    u_sdss_flux REAL,
    u_sdss_flux_error REAL,
    u_sdss_mag REAL,
    u_sdss_flag INTEGER,
    g_sdss_flux REAL,
    g_sdss_flux_error REAL,
    g_sdss_mag REAL,
    g_sdss_flag INTEGER,
    r_sdss_flux REAL,
    r_sdss_flux_error REAL,
    r_sdss_mag REAL,
    r_sdss_flag INTEGER,
    i_sdss_flux REAL,
    i_sdss_flux_error REAL,
    i_sdss_mag REAL,
    i_sdss_flag INTEGER,
    z_sdss_flux REAL,
    z_sdss_flux_error REAL,
    z_sdss_mag REAL,
    z_sdss_flag INTEGER,
    y_ps1_flux REAL,
    y_ps1_flux_error REAL,
    y_ps1_mag REAL,
    y_ps1_flag INTEGER,
    f606w_acswfc_flux REAL,
    f606w_acswfc_flux_error REAL,
    f606w_acswfc_mag REAL,
    f606w_acswfc_flag INTEGER,
    f814w_acswfc_flux REAL,
    f814w_acswfc_flux_error REAL,
    f814w_acswfc_mag REAL,
    f814w_acswfc_flag INTEGER
);
CREATE INDEX IF NOT EXISTS synthetic_photometry_gspc_source_id_idx ON synthetic_photometry_gspc (source_id);

-- [Verificación de rendimiento] vari_spurious_signals — acceso: TAP (ADQL)
CREATE TABLE IF NOT EXISTS vari_spurious_signals (
    source_id INTEGER,
    phot_variable_flag TEXT,
    in_andromeda_survey INTEGER,
    num_obs_common_all_bands INTEGER,
    num_obs_g_fov INTEGER,
    gls_freq_g_fov REAL,
    gls_freq_ampl_g_fov REAL,
    gls_freq_sde_g_fov REAL,
    gls_freq_fap_g_fov REAL,
    nhm_fund_freq_g_fov REAL,
    nhm_fund_freq_error_g_fov REAL,
    spearman_corr_exf_g_fov REAL,
    num_obs_excl_epsl_g_fov INTEGER,
    spearman_corr_ipd_g_fov REAL,
    scan_angle_model_offset_g_fov REAL,
    scan_angle_model_ampl_g_fov REAL,
    scan_angle_model_ampl_sig_g_fov REAL,
    scan_angle_model_phase_g_fov REAL,
    scan_angle_model_red_chi2_g_fov REAL,
    scan_angle_model_f2_g_fov REAL,
    spearman_corr_exf_bp REAL,
    num_obs_excl_epsl_bp INTEGER,
    spearman_corr_ipd_bp REAL,
    scan_angle_model_offset_bp REAL,
    scan_angle_model_ampl_bp REAL,
    scan_angle_model_ampl_sig_bp REAL,
    scan_angle_model_phase_bp REAL,
    scan_angle_model_red_chi2_bp REAL,
    scan_angle_model_f2_bp REAL,
    spearman_corr_exf_rp REAL,
    num_obs_excl_epsl_rp INTEGER,
    spearman_corr_ipd_rp REAL,
    scan_angle_model_offset_rp REAL,
    scan_angle_model_ampl_rp REAL,
    scan_angle_model_ampl_sig_rp REAL,
    scan_angle_model_phase_rp REAL,
    scan_angle_model_red_chi2_rp REAL,
    scan_angle_model_f2_rp REAL
);
CREATE INDEX IF NOT EXISTS vari_spurious_signals_source_id_idx ON vari_spurious_signals (source_id);

-- [Fotometría por época] epoch_photometry — acceso: DataLink (EPOCH_PHOTOMETRY)
CREATE TABLE IF NOT EXISTS epoch_photometry (
    solution_id INTEGER,
    source_id INTEGER,
    n_transits INTEGER,
    transit_id TEXT,
    g_transit_time TEXT,
    g_transit_flux TEXT,
    g_transit_flux_error TEXT,
    g_transit_flux_over_error TEXT,
    g_transit_mag TEXT,
    g_transit_n_obs TEXT,
    bp_obs_time TEXT,
    bp_flux TEXT,
    bp_flux_error TEXT,
    bp_flux_over_error TEXT,
    bp_mag TEXT,
    rp_obs_time TEXT,
    rp_flux TEXT,
    rp_flux_error TEXT,
    rp_flux_over_error TEXT,
    rp_mag TEXT,
    photometry_flag_noisy_data TEXT,
    photometry_flag_sm_unavailable TEXT,
    photometry_flag_af1_unavailable TEXT,
    photometry_flag_af2_unavailable TEXT,
    photometry_flag_af3_unavailable TEXT,
    photometry_flag_af4_unavailable TEXT,
    photometry_flag_af5_unavailable TEXT,
    photometry_flag_af6_unavailable TEXT,
    photometry_flag_af7_unavailable TEXT,
    photometry_flag_af8_unavailable TEXT,
    photometry_flag_af9_unavailable TEXT,
    photometry_flag_bp_unavailable TEXT,
    photometry_flag_rp_unavailable TEXT,
    photometry_flag_sm_reject TEXT,
    photometry_flag_af1_reject TEXT,
    photometry_flag_af2_reject TEXT,
    photometry_flag_af3_reject TEXT,
    photometry_flag_af4_reject TEXT,
    photometry_flag_af5_reject TEXT,
    photometry_flag_af6_reject TEXT,
    photometry_flag_af7_reject TEXT,
    photometry_flag_af8_reject TEXT,
    photometry_flag_af9_reject TEXT,
    photometry_flag_bp_reject TEXT,
    photometry_flag_rp_reject TEXT,
    variability_flag_g_reject TEXT,
    variability_flag_bp_reject TEXT,
    variability_flag_rp_reject TEXT
);
CREATE INDEX IF NOT EXISTS epoch_photometry_source_id_idx ON epoch_photometry (source_id);

-- [Marco de referencia] agn_cross_id — acceso: TAP (ADQL)
CREATE TABLE IF NOT EXISTS agn_cross_id (
    source_name_in_catalogue TEXT,
    source_id INTEGER,
    catalogue_name TEXT
);
CREATE INDEX IF NOT EXISTS agn_cross_id_source_id_idx ON agn_cross_id (source_id);

-- [Marco de referencia] frame_rotator_source — acceso: TAP (ADQL)
CREATE TABLE IF NOT EXISTS frame_rotator_source (
    source_id INTEGER,
    considered_for_reference_frame_orientation INTEGER,
    used_for_reference_frame_orientation INTEGER,
    considered_for_reference_frame_spin INTEGER,
    used_for_reference_frame_spin INTEGER
);
CREATE INDEX IF NOT EXISTS frame_rotator_source_source_id_idx ON frame_rotator_source (source_id);

-- [Marco de referencia] gaia_crf3_xm — acceso: TAP (ADQL)
CREATE TABLE IF NOT EXISTS gaia_crf3_xm (
    solution_id INTEGER,
    source_id INTEGER,
    icrf3sx INTEGER,
    icrf3k INTEGER,
    icrf3xka INTEGER,
    icrf_name TEXT,
    iers_name TEXT,
    ocars INTEGER,
    ocars_name TEXT,
    aw15 INTEGER,
    aw15_name TEXT,
    r90 INTEGER,
    r90_name TEXT,
    m65 INTEGER,
    m65_name TEXT,
    c75 INTEGER,
    c75_name TEXT,
    dr14q INTEGER,
    dr14q_name TEXT,
    lqac5 INTEGER,
    lqac5_name TEXT,
    lamost5 INTEGER,
    lamost5_name TEXT,
    lqrf INTEGER,
    lqrf_name TEXT,
    cat2qz INTEGER,
    cat2qz_name TEXT,
    bzcat5 INTEGER,
    bzcat5_name TEXT,
    cat2whspj INTEGER,
    cat2whspj_name TEXT,
    alma19 INTEGER,
    alma19_name TEXT,
    guw INTEGER,
    guw_name TEXT,
    b19 INTEGER,
    b19_name TEXT
);
CREATE INDEX IF NOT EXISTS gaia_crf3_xm_source_id_idx ON gaia_crf3_xm (source_id);

-- [Alertas científicas] alerts_mixedin_sourceids — acceso: TAP (ADQL)
CREATE TABLE IF NOT EXISTS alerts_mixedin_sourceids (
    solution_id INTEGER,
    alert_source_id INTEGER,
    mixed_in_source_id INTEGER
);

-- [Alertas científicas] science_alerts — acceso: TAP (ADQL)
CREATE TABLE IF NOT EXISTS science_alerts (
    source_id INTEGER,
    transit_id INTEGER,
    name TEXT,
    solution_id INTEGER
);
CREATE INDEX IF NOT EXISTS science_alerts_source_id_idx ON science_alerts (source_id);

-- [Sistema solar] sso_observation — acceso: TAP (ADQL)
CREATE TABLE IF NOT EXISTS sso_observation (
    solution_id INTEGER,
    source_id INTEGER,
    denomination TEXT,
    transit_id INTEGER,
    observation_id INTEGER,
    number_mp INTEGER,
    epoch REAL,
    epoch_err REAL,
    epoch_utc REAL,
    ra REAL,
    dec REAL,
    ra_error_systematic REAL,
    dec_error_systematic REAL,
    ra_dec_correlation_systematic REAL,
    ra_error_random REAL,
    dec_error_random REAL,
    ra_dec_correlation_random REAL,
    g_mag REAL,
    g_flux REAL,
    g_flux_error REAL,
    x_gaia REAL,
    y_gaia REAL,
    z_gaia REAL,
    vx_gaia REAL,
    vy_gaia REAL,
    vz_gaia REAL,
    x_gaia_geocentric REAL,
    y_gaia_geocentric REAL,
    z_gaia_geocentric REAL,
    vx_gaia_geocentric REAL,
    vy_gaia_geocentric REAL,
    vz_gaia_geocentric REAL,
    position_angle_scan REAL,
    astrometric_outcome_ccd TEXT,
    astrometric_outcome_transit INTEGER
);
CREATE INDEX IF NOT EXISTS sso_observation_source_id_idx ON sso_observation (source_id);

-- [Sistema solar] sso_reflectance_spectrum — acceso: TAP (ADQL)
CREATE TABLE IF NOT EXISTS sso_reflectance_spectrum (
    source_id INTEGER,
    solution_id INTEGER,
    number_mp INTEGER,
    denomination TEXT,
    nb_samples INTEGER,
    num_of_spectra INTEGER,
    reflectance_spectrum REAL,
    reflectance_spectrum_err REAL,
    wavelength REAL,
    reflectance_spectrum_flag INTEGER
);
CREATE INDEX IF NOT EXISTS sso_reflectance_spectrum_source_id_idx ON sso_reflectance_spectrum (source_id);

-- [Sistema solar] sso_source — acceso: TAP (ADQL)
CREATE TABLE IF NOT EXISTS sso_source (
    solution_id INTEGER,
    source_id INTEGER,
    num_of_obs INTEGER,
    number_mp INTEGER,
    denomination TEXT,
    num_of_spectra INTEGER
);
CREATE INDEX IF NOT EXISTS sso_source_source_id_idx ON sso_source (source_id);

-- [Espectroscopía] rvs_mean_spectrum — acceso: DataLink (RVS)
CREATE TABLE IF NOT EXISTS rvs_mean_spectrum (
    source_id INTEGER,
    solution_id INTEGER,
    ra REAL,
    dec REAL,
    flux TEXT,
    flux_error TEXT,
    combined_transits INTEGER,
    combined_ccds INTEGER,
    deblended_ccds INTEGER
);
CREATE INDEX IF NOT EXISTS rvs_mean_spectrum_source_id_idx ON rvs_mean_spectrum (source_id);

-- [Espectroscopía] xp_continuous_mean_spectrum — acceso: DataLink (XP_CONTINUOUS)
CREATE TABLE IF NOT EXISTS xp_continuous_mean_spectrum (
    source_id INTEGER,
    solution_id INTEGER,
    bp_basis_function_id INTEGER,
    bp_degrees_of_freedom INTEGER,
    bp_n_parameters INTEGER,
    bp_n_measurements INTEGER,
    bp_n_rejected_measurements INTEGER,
    bp_standard_deviation REAL,
    bp_chi_squared REAL,
    bp_coefficients TEXT,
    bp_coefficient_errors TEXT,
    bp_coefficient_correlations TEXT,
    bp_n_relevant_bases INTEGER,
    bp_relative_shrinking REAL,
    rp_basis_function_id INTEGER,
    rp_degrees_of_freedom INTEGER,
    rp_n_parameters INTEGER,
    rp_n_measurements INTEGER,
    rp_n_rejected_measurements INTEGER,
    rp_standard_deviation REAL,
    rp_chi_squared REAL,
    rp_coefficients TEXT,
    rp_coefficient_errors TEXT,
    rp_coefficient_correlations TEXT,
    rp_n_relevant_bases INTEGER,
    rp_relative_shrinking REAL
);
CREATE INDEX IF NOT EXISTS xp_continuous_mean_spectrum_source_id_idx ON xp_continuous_mean_spectrum (source_id);

-- [Espectroscopía] xp_sampled_mean_spectrum — acceso: DataLink (XP_SAMPLED)
CREATE TABLE IF NOT EXISTS xp_sampled_mean_spectrum (
    source_id INTEGER,
    solution_id INTEGER,
    ra REAL,
    dec REAL,
    flux TEXT,
    flux_error TEXT
);
CREATE INDEX IF NOT EXISTS xp_sampled_mean_spectrum_source_id_idx ON xp_sampled_mean_spectrum (source_id);

-- [Espectroscopía] xp_summary — acceso: TAP (ADQL)
CREATE TABLE IF NOT EXISTS xp_summary (
    source_id INTEGER,
    solution_id INTEGER,
    bp_n_relevant_bases INTEGER,
    bp_relative_shrinking REAL,
    bp_n_measurements INTEGER,
    bp_n_rejected_measurements INTEGER,
    bp_standard_deviation REAL,
    bp_chi_squared REAL,
    bp_n_transits INTEGER,
    bp_n_contaminated_transits INTEGER,
    bp_n_blended_transits INTEGER,
    rp_n_relevant_bases INTEGER,
    rp_relative_shrinking REAL,
    rp_n_measurements INTEGER,
    rp_n_rejected_measurements INTEGER,
    rp_standard_deviation REAL,
    rp_chi_squared REAL,
    rp_n_transits INTEGER,
    rp_n_contaminated_transits INTEGER,
    rp_n_blended_transits INTEGER
);
CREATE INDEX IF NOT EXISTS xp_summary_source_id_idx ON xp_summary (source_id);

-- [Variabilidad] vari_agn — acceso: TAP (ADQL)
CREATE TABLE IF NOT EXISTS vari_agn (
    solution_id INTEGER,
    source_id INTEGER,
    fractional_variability_g REAL,
    structure_function_index REAL,
    structure_function_index_scatter REAL,
    qso_variability REAL,
    non_qso_variability REAL
);
CREATE INDEX IF NOT EXISTS vari_agn_source_id_idx ON vari_agn (source_id);

-- [Variabilidad] vari_cepheid — acceso: TAP (ADQL)
CREATE TABLE IF NOT EXISTS vari_cepheid (
    solution_id INTEGER,
    source_id INTEGER,
    pf REAL,
    pf_error REAL,
    p1_o REAL,
    p1_o_error REAL,
    epoch_g REAL,
    epoch_g_error REAL,
    epoch_bp REAL,
    epoch_bp_error REAL,
    epoch_rp REAL,
    epoch_rp_error REAL,
    epoch_rv REAL,
    epoch_rv_error REAL,
    int_average_g REAL,
    int_average_g_error REAL,
    int_average_bp REAL,
    int_average_bp_error REAL,
    int_average_rp REAL,
    int_average_rp_error REAL,
    average_rv REAL,
    average_rv_error REAL,
    peak_to_peak_g REAL,
    peak_to_peak_g_error REAL,
    peak_to_peak_bp REAL,
    peak_to_peak_bp_error REAL,
    peak_to_peak_rp REAL,
    peak_to_peak_rp_error REAL,
    peak_to_peak_rv REAL,
    peak_to_peak_rv_error REAL,
    metallicity REAL,
    metallicity_error REAL,
    r21_g REAL,
    r21_g_error REAL,
    r31_g REAL,
    r31_g_error REAL,
    phi21_g REAL,
    phi21_g_error REAL,
    phi31_g REAL,
    phi31_g_error REAL,
    num_clean_epochs_g INTEGER,
    num_clean_epochs_bp INTEGER,
    num_clean_epochs_rp INTEGER,
    num_clean_epochs_rv INTEGER,
    zp_mag_g REAL,
    zp_mag_bp REAL,
    zp_mag_rp REAL,
    num_harmonics_for_p1_g INTEGER,
    num_harmonics_for_p1_bp INTEGER,
    num_harmonics_for_p1_rp INTEGER,
    num_harmonics_for_p1_rv INTEGER,
    reference_time_g REAL,
    reference_time_bp REAL,
    reference_time_rp REAL,
    reference_time_rv REAL,
    fund_freq1 REAL,
    fund_freq1_error REAL,
    fund_freq2 REAL,
    fund_freq2_error REAL,
    fund_freq1_harmonic_ampl_g TEXT,
    fund_freq1_harmonic_ampl_g_error TEXT,
    fund_freq1_harmonic_phase_g TEXT,
    fund_freq1_harmonic_phase_g_error TEXT,
    fund_freq1_harmonic_ampl_bp TEXT,
    fund_freq1_harmonic_ampl_bp_error TEXT,
    fund_freq1_harmonic_phase_bp TEXT,
    fund_freq1_harmonic_phase_bp_error TEXT,
    fund_freq1_harmonic_ampl_rp TEXT,
    fund_freq1_harmonic_ampl_rp_error TEXT,
    fund_freq1_harmonic_phase_rp TEXT,
    fund_freq1_harmonic_phase_rp_error TEXT,
    fund_freq1_harmonic_ampl_rv TEXT,
    fund_freq1_harmonic_ampl_rv_error TEXT,
    fund_freq1_harmonic_phase_rv TEXT,
    fund_freq1_harmonic_phase_rv_error TEXT,
    p2_o REAL,
    p2_o_error REAL,
    type_best_classification TEXT,
    type2_best_sub_classification TEXT,
    mode_best_classification TEXT,
    multi_mode_best_classification TEXT
);
CREATE INDEX IF NOT EXISTS vari_cepheid_source_id_idx ON vari_cepheid (source_id);

-- [Variabilidad] vari_classifier_class_definition — acceso: TAP (ADQL)
CREATE TABLE IF NOT EXISTS vari_classifier_class_definition (
    solution_id INTEGER,
    classifier_name TEXT,
    class_name TEXT,
    class_description TEXT
);

-- [Variabilidad] vari_classifier_definition — acceso: TAP (ADQL)
CREATE TABLE IF NOT EXISTS vari_classifier_definition (
    solution_id INTEGER,
    classifier_name TEXT,
    classifier_description TEXT
);

-- [Variabilidad] vari_classifier_result — acceso: TAP (ADQL)
CREATE TABLE IF NOT EXISTS vari_classifier_result (
    solution_id INTEGER,
    source_id INTEGER,
    classifier_name TEXT,
    best_class_name TEXT,
    best_class_score REAL
);
CREATE INDEX IF NOT EXISTS vari_classifier_result_source_id_idx ON vari_classifier_result (source_id);

-- [Variabilidad] vari_compact_companion — acceso: TAP (ADQL)
CREATE TABLE IF NOT EXISTS vari_compact_companion (
    solution_id INTEGER,
    source_id INTEGER,
    period REAL,
    period_error REAL,
    t0_g REAL,
    t0_g_error REAL,
    t0_bp REAL,
    t0_bp_error REAL,
    t0_rp REAL,
    t0_rp_error REAL,
    harmonic_model_params_g TEXT,
    harmonic_model_params_g_error TEXT,
    harmonic_model_params_bp TEXT,
    harmonic_model_params_bp_error TEXT,
    harmonic_model_params_rp TEXT,
    harmonic_model_params_rp_error TEXT,
    model_mean_g REAL,
    model_mean_g_error REAL,
    model_mean_bp REAL,
    model_mean_bp_error REAL,
    model_mean_rp REAL,
    model_mean_rp_error REAL,
    mod_min_mass_ratio REAL,
    mod_min_mass_ratio_one_sigma REAL,
    mod_min_mass_ratio_three_sigma REAL,
    alpha REAL
);
CREATE INDEX IF NOT EXISTS vari_compact_companion_source_id_idx ON vari_compact_companion (source_id);

-- [Variabilidad] vari_eclipsing_binary — acceso: TAP (ADQL)
CREATE TABLE IF NOT EXISTS vari_eclipsing_binary (
    solution_id INTEGER,
    source_id INTEGER,
    global_ranking REAL,
    reference_time REAL,
    frequency REAL,
    frequency_error REAL,
    geom_model_reference_level REAL,
    geom_model_reference_level_error REAL,
    geom_model_gaussian1_phase REAL,
    geom_model_gaussian1_phase_error REAL,
    geom_model_gaussian1_sigma REAL,
    geom_model_gaussian1_sigma_error REAL,
    geom_model_gaussian1_depth REAL,
    geom_model_gaussian1_depth_error REAL,
    geom_model_gaussian2_phase REAL,
    geom_model_gaussian2_phase_error REAL,
    geom_model_gaussian2_sigma REAL,
    geom_model_gaussian2_sigma_error REAL,
    geom_model_gaussian2_depth REAL,
    geom_model_gaussian2_depth_error REAL,
    geom_model_cosine_half_period_amplitude REAL,
    geom_model_cosine_half_period_amplitude_error REAL,
    geom_model_cosine_half_period_phase REAL,
    geom_model_cosine_half_period_phase_error REAL,
    model_type TEXT,
    num_model_parameters INTEGER,
    reduced_chi2 REAL,
    derived_primary_ecl_phase REAL,
    derived_primary_ecl_phase_error REAL,
    derived_primary_ecl_duration REAL,
    derived_primary_ecl_duration_error REAL,
    derived_primary_ecl_depth REAL,
    derived_primary_ecl_depth_error REAL,
    derived_secondary_ecl_phase REAL,
    derived_secondary_ecl_phase_error REAL,
    derived_secondary_ecl_duration REAL,
    derived_secondary_ecl_duration_error REAL,
    derived_secondary_ecl_depth REAL,
    derived_secondary_ecl_depth_error REAL
);
CREATE INDEX IF NOT EXISTS vari_eclipsing_binary_source_id_idx ON vari_eclipsing_binary (source_id);

-- [Variabilidad] vari_epoch_radial_velocity — acceso: TAP (ADQL)
CREATE TABLE IF NOT EXISTS vari_epoch_radial_velocity (
    source_id INTEGER,
    transit_id INTEGER,
    rv_obs_time REAL,
    radial_velocity REAL,
    radial_velocity_error REAL,
    rejected_by_variability INTEGER,
    solution_id INTEGER
);
CREATE INDEX IF NOT EXISTS vari_epoch_radial_velocity_source_id_idx ON vari_epoch_radial_velocity (source_id);

-- [Variabilidad] vari_long_period_variable — acceso: TAP (ADQL)
CREATE TABLE IF NOT EXISTS vari_long_period_variable (
    solution_id INTEGER,
    source_id INTEGER,
    frequency REAL,
    frequency_error REAL,
    amplitude REAL,
    median_delta_wl_rp REAL,
    is_cstar INTEGER
);
CREATE INDEX IF NOT EXISTS vari_long_period_variable_source_id_idx ON vari_long_period_variable (source_id);

-- [Variabilidad] vari_microlensing — acceso: TAP (ADQL)
CREATE TABLE IF NOT EXISTS vari_microlensing (
    solution_id INTEGER,
    source_id INTEGER,
    paczynski0_g0 REAL,
    paczynski0_g0_error REAL,
    paczynski0_bp0 REAL,
    paczynski0_bp0_error REAL,
    paczynski0_rp0 REAL,
    paczynski0_rp0_error REAL,
    paczynski0_u0 REAL,
    paczynski0_u0_error REAL,
    paczynski0_te REAL,
    paczynski0_te_error REAL,
    paczynski0_tmax REAL,
    paczynski0_tmax_error REAL,
    paczynski0_chi2 REAL,
    paczynski0_chi2_dof REAL,
    paczynski1_g0 REAL,
    paczynski1_g0_error REAL,
    paczynski1_bp0 REAL,
    paczynski1_bp0_error REAL,
    paczynski1_rp0 REAL,
    paczynski1_rp0_error REAL,
    paczynski1_u0 REAL,
    paczynski1_u0_error REAL,
    paczynski1_te REAL,
    paczynski1_te_error REAL,
    paczynski1_tmax REAL,
    paczynski1_tmax_error REAL,
    paczynski1_fs_g REAL,
    paczynski1_fs_g_error REAL,
    paczynski1_fs_bp REAL,
    paczynski1_fs_bp_error REAL,
    paczynski1_fs_rp REAL,
    paczynski1_fs_rp_error REAL,
    paczynski1_chi2 REAL,
    paczynski1_chi2_dof REAL
);
CREATE INDEX IF NOT EXISTS vari_microlensing_source_id_idx ON vari_microlensing (source_id);

-- [Variabilidad] vari_ms_oscillator — acceso: TAP (ADQL)
CREATE TABLE IF NOT EXISTS vari_ms_oscillator (
    solution_id INTEGER,
    source_id INTEGER,
    frequency1 REAL,
    fap_g_freq1 REAL,
    amplitude_g_freq1 REAL,
    phase_g_freq1 REAL,
    num_harmonics INTEGER,
    amplitude_g_freq1_harm2 REAL,
    phase_g_freq1_harm2 REAL,
    amplitude_g_freq1_harm3 REAL,
    phase_g_freq1_harm3 REAL
);
CREATE INDEX IF NOT EXISTS vari_ms_oscillator_source_id_idx ON vari_ms_oscillator (source_id);

-- [Variabilidad] vari_planetary_transit — acceso: TAP (ADQL)
CREATE TABLE IF NOT EXISTS vari_planetary_transit (
    solution_id INTEGER,
    source_id INTEGER,
    transit_reference_time REAL,
    transit_period REAL,
    transit_depth REAL,
    transit_duration REAL,
    num_in_transit INTEGER
);
CREATE INDEX IF NOT EXISTS vari_planetary_transit_source_id_idx ON vari_planetary_transit (source_id);

-- [Variabilidad] vari_planetary_transit_13june2022 — acceso: TAP (ADQL)
CREATE TABLE IF NOT EXISTS vari_planetary_transit_13june2022 (
    solution_id INTEGER,
    source_id INTEGER,
    transit_reference_time REAL,
    transit_period REAL,
    transit_depth REAL,
    transit_duration REAL,
    num_in_transit INTEGER
);
CREATE INDEX IF NOT EXISTS vari_planetary_transit_13june2022_source_id_idx ON vari_planetary_transit_13june2022 (source_id);

-- [Variabilidad] vari_rad_vel_statistics — acceso: TAP (ADQL)
CREATE TABLE IF NOT EXISTS vari_rad_vel_statistics (
    solution_id INTEGER,
    source_id INTEGER,
    num_selected_rv INTEGER,
    mean_obs_time_rv REAL,
    time_duration_rv REAL,
    min_rv REAL,
    max_rv REAL,
    mean_rv REAL,
    median_rv REAL,
    range_rv REAL,
    std_dev_rv REAL,
    skewness_rv REAL,
    kurtosis_rv REAL,
    mad_rv REAL,
    abbe_rv REAL,
    iqr_rv REAL
);
CREATE INDEX IF NOT EXISTS vari_rad_vel_statistics_source_id_idx ON vari_rad_vel_statistics (source_id);

-- [Variabilidad] vari_rotation_modulation — acceso: TAP (ADQL)
CREATE TABLE IF NOT EXISTS vari_rotation_modulation (
    solution_id INTEGER,
    source_id INTEGER,
    num_segments INTEGER,
    segments_start_time TEXT,
    segments_end_time TEXT,
    segments_colour_mag_intercept TEXT,
    segments_colour_mag_intercept_error TEXT,
    segments_colour_mag_slope TEXT,
    segments_colour_mag_slope_error TEXT,
    segments_correlation_coefficient TEXT,
    segments_correlation_significance TEXT,
    num_outliers INTEGER,
    outliers_time TEXT,
    segments_rotation_period TEXT,
    segments_rotation_period_error TEXT,
    segments_rotation_period_fap TEXT,
    best_rotation_period REAL,
    best_rotation_period_error REAL,
    segments_g_unspotted TEXT,
    segments_g_unspotted_error TEXT,
    segments_bp_unspotted TEXT,
    segments_bp_unspotted_error TEXT,
    segments_rp_unspotted TEXT,
    segments_rp_unspotted_error TEXT,
    g_unspotted REAL,
    g_unspotted_error REAL,
    bp_unspotted REAL,
    bp_unspotted_error REAL,
    rp_unspotted REAL,
    rp_unspotted_error REAL,
    segments_g_cos_term TEXT,
    segments_g_cos_term_error TEXT,
    segments_g_sin_term TEXT,
    segments_g_sin_term_error TEXT,
    segments_g_a0_term TEXT,
    segments_g_a0_term_error TEXT,
    segments_bp_cos_term TEXT,
    segments_bp_cos_term_error TEXT,
    segments_bp_sin_term TEXT,
    segments_bp_sin_term_error TEXT,
    segments_bp_a0_term TEXT,
    segments_bp_a0_term_error TEXT,
    segments_rp_cos_term TEXT,
    segments_rp_cos_term_error TEXT,
    segments_rp_sin_term TEXT,
    segments_rp_sin_term_error TEXT,
    segments_rp_a0_term TEXT,
    segments_rp_a0_term_error TEXT,
    segments_g_activity_index TEXT,
    segments_g_activity_index_error TEXT,
    segments_bp_activity_index TEXT,
    segments_bp_activity_index_error TEXT,
    segments_rp_activity_index TEXT,
    segments_rp_activity_index_error TEXT,
    max_activity_index_g REAL,
    max_activity_index_g_error REAL,
    segments_bp_rp_corr_coeff TEXT,
    segments_bp_rp_corr_signif TEXT,
    segments_bp_rp_intercept TEXT,
    segments_bp_rp_intercept_error TEXT,
    segments_bp_rp_slope TEXT,
    segments_bp_rp_slope_error TEXT,
    segments_model_reference_time TEXT,
    segments_g_chi_square TEXT,
    segments_bp_chi_square TEXT,
    segments_rp_chi_square TEXT
);
CREATE INDEX IF NOT EXISTS vari_rotation_modulation_source_id_idx ON vari_rotation_modulation (source_id);

-- [Variabilidad] vari_rrlyrae — acceso: TAP (ADQL)
CREATE TABLE IF NOT EXISTS vari_rrlyrae (
    solution_id INTEGER,
    source_id INTEGER,
    pf REAL,
    pf_error REAL,
    p1_o REAL,
    p1_o_error REAL,
    epoch_g REAL,
    epoch_g_error REAL,
    epoch_bp REAL,
    epoch_bp_error REAL,
    epoch_rp REAL,
    epoch_rp_error REAL,
    epoch_rv REAL,
    epoch_rv_error REAL,
    int_average_g REAL,
    int_average_g_error REAL,
    int_average_bp REAL,
    int_average_bp_error REAL,
    int_average_rp REAL,
    int_average_rp_error REAL,
    average_rv REAL,
    average_rv_error REAL,
    peak_to_peak_g REAL,
    peak_to_peak_g_error REAL,
    peak_to_peak_bp REAL,
    peak_to_peak_bp_error REAL,
    peak_to_peak_rp REAL,
    peak_to_peak_rp_error REAL,
    peak_to_peak_rv REAL,
    peak_to_peak_rv_error REAL,
    metallicity REAL,
    metallicity_error REAL,
    r21_g REAL,
    r21_g_error REAL,
    r31_g REAL,
    r31_g_error REAL,
    phi21_g REAL,
    phi21_g_error REAL,
    phi31_g REAL,
    phi31_g_error REAL,
    num_clean_epochs_g INTEGER,
    num_clean_epochs_bp INTEGER,
    num_clean_epochs_rp INTEGER,
    num_clean_epochs_rv INTEGER,
    zp_mag_g REAL,
    zp_mag_bp REAL,
    zp_mag_rp REAL,
    num_harmonics_for_p1_g INTEGER,
    num_harmonics_for_p1_bp INTEGER,
    num_harmonics_for_p1_rp INTEGER,
    num_harmonics_for_p1_rv INTEGER,
    reference_time_g REAL,
    reference_time_bp REAL,
    reference_time_rp REAL,
    reference_time_rv REAL,
    fund_freq1 REAL,
    fund_freq1_error REAL,
    fund_freq2 REAL,
    fund_freq2_error REAL,
    fund_freq1_harmonic_ampl_g TEXT,
    fund_freq1_harmonic_ampl_g_error TEXT,
    fund_freq1_harmonic_phase_g TEXT,
    fund_freq1_harmonic_phase_g_error TEXT,
    fund_freq1_harmonic_ampl_bp TEXT,
    fund_freq1_harmonic_ampl_bp_error TEXT,
    fund_freq1_harmonic_phase_bp TEXT,
    fund_freq1_harmonic_phase_bp_error TEXT,
    fund_freq1_harmonic_ampl_rp TEXT,
    fund_freq1_harmonic_ampl_rp_error TEXT,
    fund_freq1_harmonic_phase_rp TEXT,
    fund_freq1_harmonic_phase_rp_error TEXT,
    fund_freq1_harmonic_ampl_rv TEXT,
    fund_freq1_harmonic_ampl_rv_error TEXT,
    fund_freq1_harmonic_phase_rv TEXT,
    fund_freq1_harmonic_phase_rv_error TEXT,
    best_classification TEXT,
    g_absorption REAL,
    g_absorption_error REAL
);
CREATE INDEX IF NOT EXISTS vari_rrlyrae_source_id_idx ON vari_rrlyrae (source_id);

-- [Variabilidad] vari_short_timescale — acceso: TAP (ADQL)
CREATE TABLE IF NOT EXISTS vari_short_timescale (
    solution_id INTEGER,
    source_id INTEGER,
    amplitude_estimate REAL,
    number_of_fov_transits INTEGER,
    mean_of_fov_abbe_values REAL,
    variogram_num_points INTEGER,
    variogram_char_timescales TEXT,
    variogram_values TEXT,
    frequency REAL
);
CREATE INDEX IF NOT EXISTS vari_short_timescale_source_id_idx ON vari_short_timescale (source_id);

-- [Variabilidad] vari_summary — acceso: TAP (ADQL)
CREATE TABLE IF NOT EXISTS vari_summary (
    solution_id INTEGER,
    source_id INTEGER,
    num_selected_g_fov INTEGER,
    mean_obs_time_g_fov REAL,
    time_duration_g_fov REAL,
    min_mag_g_fov REAL,
    max_mag_g_fov REAL,
    mean_mag_g_fov REAL,
    median_mag_g_fov REAL,
    range_mag_g_fov REAL,
    trimmed_range_mag_g_fov REAL,
    std_dev_mag_g_fov REAL,
    skewness_mag_g_fov REAL,
    kurtosis_mag_g_fov REAL,
    mad_mag_g_fov REAL,
    abbe_mag_g_fov REAL,
    iqr_mag_g_fov REAL,
    stetson_mag_g_fov REAL,
    std_dev_over_rms_err_mag_g_fov REAL,
    outlier_median_g_fov REAL,
    num_selected_bp INTEGER,
    mean_obs_time_bp REAL,
    time_duration_bp REAL,
    min_mag_bp REAL,
    max_mag_bp REAL,
    mean_mag_bp REAL,
    median_mag_bp REAL,
    range_mag_bp REAL,
    trimmed_range_mag_bp REAL,
    std_dev_mag_bp REAL,
    skewness_mag_bp REAL,
    kurtosis_mag_bp REAL,
    mad_mag_bp REAL,
    abbe_mag_bp REAL,
    iqr_mag_bp REAL,
    stetson_mag_bp REAL,
    std_dev_over_rms_err_mag_bp REAL,
    outlier_median_bp REAL,
    num_selected_rp INTEGER,
    mean_obs_time_rp REAL,
    time_duration_rp REAL,
    min_mag_rp REAL,
    max_mag_rp REAL,
    mean_mag_rp REAL,
    median_mag_rp REAL,
    range_mag_rp REAL,
    trimmed_range_mag_rp REAL,
    std_dev_mag_rp REAL,
    skewness_mag_rp REAL,
    kurtosis_mag_rp REAL,
    mad_mag_rp REAL,
    abbe_mag_rp REAL,
    iqr_mag_rp REAL,
    stetson_mag_rp REAL,
    std_dev_over_rms_err_mag_rp REAL,
    outlier_median_rp REAL,
    in_vari_classification_result INTEGER,
    in_vari_rrlyrae INTEGER,
    in_vari_cepheid INTEGER,
    in_vari_planetary_transit INTEGER,
    in_vari_short_timescale INTEGER,
    in_vari_long_period_variable INTEGER,
    in_vari_eclipsing_binary INTEGER,
    in_vari_rotation_modulation INTEGER,
    in_vari_ms_oscillator INTEGER,
    in_vari_agn INTEGER,
    in_vari_microlensing INTEGER,
    in_vari_compact_companion INTEGER
);
CREATE INDEX IF NOT EXISTS vari_summary_source_id_idx ON vari_summary (source_id);

-- [Simulación] gaia_source_simulation — acceso: TAP (ADQL)
CREATE TABLE IF NOT EXISTS gaia_source_simulation (
    solution_id INTEGER,
    source_id INTEGER,
    ra REAL,
    ra_error REAL,
    dec REAL,
    dec_error REAL,
    parallax REAL,
    parallax_error REAL,
    pmra REAL,
    pmra_error REAL,
    pmdec REAL,
    pmdec_error REAL,
    n_obs_al INTEGER,
    n_outliers_al INTEGER,
    phot_g_mean_flux REAL,
    phot_g_mean_flux_error REAL,
    phot_g_mean_mag REAL,
    phot_bp_mean_flux REAL,
    phot_bp_mean_flux_error REAL,
    phot_bp_mean_mag REAL,
    phot_rp_mean_flux REAL,
    phot_rp_mean_flux_error REAL,
    phot_rp_mean_mag REAL,
    phot_rvs_mean_flux REAL,
    phot_rvs_mean_flux_error REAL,
    phot_rvs_mean_mag REAL,
    radial_velocity REAL,
    radial_velocity_error REAL,
    teff REAL,
    teff_error REAL,
    vsini REAL,
    vsini_error REAL,
    a0 REAL,
    a0_error REAL,
    feh REAL,
    feh_error REAL,
    logg REAL,
    logg_error REAL
);
CREATE INDEX IF NOT EXISTS gaia_source_simulation_source_id_idx ON gaia_source_simulation (source_id);

-- [Simulación] gaia_universe_model — acceso: TAP (ADQL)
CREATE TABLE IF NOT EXISTS gaia_universe_model (
    source_extended_id TEXT,
    source_id INTEGER,
    solution_id INTEGER,
    ra REAL,
    dec REAL,
    barycentric_distance REAL,
    pmra REAL,
    pmdec REAL,
    radial_velocity REAL,
    mag_g REAL,
    mag_bp REAL,
    mag_rp REAL,
    mag_rvs REAL,
    v_i REAL,
    mean_absolute_v REAL,
    ag REAL,
    av REAL,
    teff REAL,
    spectral_type TEXT,
    logg REAL,
    feh REAL,
    alphafe REAL,
    mbol REAL,
    age REAL,
    mass REAL,
    radius REAL,
    vsini REAL,
    population INTEGER,
    has_photocenter_motion INTEGER,
    nc INTEGER,
    nt INTEGER,
    semimajor_axis REAL,
    eccentricity REAL,
    inclination REAL,
    longitude_ascending_node REAL,
    orbit_period REAL,
    periastron_date REAL,
    periastron_argument REAL,
    variability_type TEXT,
    variability_amplitude REAL,
    variability_period REAL,
    variability_phase REAL,
    r_env_r_star REAL
);
CREATE INDEX IF NOT EXISTS gaia_universe_model_source_id_idx ON gaia_universe_model (source_id);

-- [Auxiliar] commanded_scan_law — acceso: TAP (ADQL)
CREATE TABLE IF NOT EXISTS commanded_scan_law (
    jd_time REAL,
    bjd_fov1 REAL,
    bjd_fov2 REAL,
    obmt_time INTEGER,
    ra_fov1 REAL,
    dec_fov1 REAL,
    heal_pix_fov1 INTEGER,
    scan_angle_fov1 REAL,
    ra_fov2 REAL,
    dec_fov2 REAL,
    heal_pix_fov2 INTEGER,
    scan_angle_fov2 REAL,
    solution_id INTEGER
);

