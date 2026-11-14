-- Esquema v2 (Gaia DR3 + SPHEREx) para PostgreSQL. Generado por scripts/02_generar_esquema.py
CREATE SCHEMA IF NOT EXISTS gaiadr3;
CREATE SCHEMA IF NOT EXISTS spherex;
CREATE SCHEMA IF NOT EXISTS proyecto;

-- [Catálogo principal] gaiadr3.gaia_source — acceso: TAP Gaia (ADQL)
CREATE TABLE IF NOT EXISTS gaiadr3.gaia_source (
    solution_id bigint,
    designation text,
    source_id bigint,
    random_index bigint,
    ref_epoch double precision,
    ra double precision,
    ra_error real,
    dec double precision,
    dec_error real,
    parallax double precision,
    parallax_error real,
    parallax_over_error real,
    pm real,
    pmra double precision,
    pmra_error real,
    pmdec double precision,
    pmdec_error real,
    ra_dec_corr real,
    ra_parallax_corr real,
    ra_pmra_corr real,
    ra_pmdec_corr real,
    dec_parallax_corr real,
    dec_pmra_corr real,
    dec_pmdec_corr real,
    parallax_pmra_corr real,
    parallax_pmdec_corr real,
    pmra_pmdec_corr real,
    astrometric_n_obs_al smallint,
    astrometric_n_obs_ac smallint,
    astrometric_n_good_obs_al smallint,
    astrometric_n_bad_obs_al smallint,
    astrometric_gof_al real,
    astrometric_chi2_al real,
    astrometric_excess_noise real,
    astrometric_excess_noise_sig real,
    astrometric_params_solved smallint,
    astrometric_primary_flag boolean,
    nu_eff_used_in_astrometry real,
    pseudocolour real,
    pseudocolour_error real,
    ra_pseudocolour_corr real,
    dec_pseudocolour_corr real,
    parallax_pseudocolour_corr real,
    pmra_pseudocolour_corr real,
    pmdec_pseudocolour_corr real,
    astrometric_matched_transits smallint,
    visibility_periods_used smallint,
    astrometric_sigma5d_max real,
    matched_transits smallint,
    new_matched_transits smallint,
    matched_transits_removed smallint,
    ipd_gof_harmonic_amplitude real,
    ipd_gof_harmonic_phase real,
    ipd_frac_multi_peak smallint,
    ipd_frac_odd_win smallint,
    ruwe real,
    scan_direction_strength_k1 real,
    scan_direction_strength_k2 real,
    scan_direction_strength_k3 real,
    scan_direction_strength_k4 real,
    scan_direction_mean_k1 real,
    scan_direction_mean_k2 real,
    scan_direction_mean_k3 real,
    scan_direction_mean_k4 real,
    duplicated_source boolean,
    phot_g_n_obs smallint,
    phot_g_mean_flux double precision,
    phot_g_mean_flux_error real,
    phot_g_mean_flux_over_error real,
    phot_g_mean_mag real,
    phot_bp_n_obs smallint,
    phot_bp_mean_flux double precision,
    phot_bp_mean_flux_error real,
    phot_bp_mean_flux_over_error real,
    phot_bp_mean_mag real,
    phot_rp_n_obs smallint,
    phot_rp_mean_flux double precision,
    phot_rp_mean_flux_error real,
    phot_rp_mean_flux_over_error real,
    phot_rp_mean_mag real,
    phot_bp_rp_excess_factor real,
    phot_bp_n_contaminated_transits smallint,
    phot_bp_n_blended_transits smallint,
    phot_rp_n_contaminated_transits smallint,
    phot_rp_n_blended_transits smallint,
    phot_proc_mode smallint,
    bp_rp real,
    bp_g real,
    g_rp real,
    radial_velocity real,
    radial_velocity_error real,
    rv_method_used smallint,
    rv_nb_transits smallint,
    rv_nb_deblended_transits smallint,
    rv_visibility_periods_used smallint,
    rv_expected_sig_to_noise real,
    rv_renormalised_gof real,
    rv_chisq_pvalue real,
    rv_time_duration real,
    rv_amplitude_robust real,
    rv_template_teff real,
    rv_template_logg real,
    rv_template_fe_h real,
    rv_atm_param_origin smallint,
    vbroad real,
    vbroad_error real,
    vbroad_nb_transits smallint,
    grvs_mag real,
    grvs_mag_error real,
    grvs_mag_nb_transits smallint,
    rvs_spec_sig_to_noise real,
    phot_variable_flag text,
    l double precision,
    b double precision,
    ecl_lon double precision,
    ecl_lat double precision,
    in_qso_candidates boolean,
    in_galaxy_candidates boolean,
    non_single_star smallint,
    has_xp_continuous boolean,
    has_xp_sampled boolean,
    has_rvs boolean,
    has_epoch_photometry boolean,
    has_epoch_rv boolean,
    has_mcmc_gspphot boolean,
    has_mcmc_msc boolean,
    in_andromeda_survey boolean,
    classprob_dsc_combmod_quasar real,
    classprob_dsc_combmod_galaxy real,
    classprob_dsc_combmod_star real,
    teff_gspphot real,
    teff_gspphot_lower real,
    teff_gspphot_upper real,
    logg_gspphot real,
    logg_gspphot_lower real,
    logg_gspphot_upper real,
    mh_gspphot real,
    mh_gspphot_lower real,
    mh_gspphot_upper real,
    distance_gspphot real,
    distance_gspphot_lower real,
    distance_gspphot_upper real,
    azero_gspphot real,
    azero_gspphot_lower real,
    azero_gspphot_upper real,
    ag_gspphot real,
    ag_gspphot_lower real,
    ag_gspphot_upper real,
    ebpminrp_gspphot real,
    ebpminrp_gspphot_lower real,
    ebpminrp_gspphot_upper real,
    libname_gspphot text
);
COMMENT ON TABLE gaiadr3.gaia_source IS 'This table has an entry for every Gaia observed source as published with this data release. It contains the basic source parameters, in their final state as processed by the Gaia Data Processing and Analysis Consortium from the raw data coming from the spacecraft. The table is complemented with others containing information specific to certain kinds of objects (e.g.~Solar--system objects, non--single stars, variables etc.) and value--added processing (e.g.~astrophysical parameters etc.). Further array data types (spectra, epoch measurements) are presented separately via Datalink resources.';
COMMENT ON COLUMN gaiadr3.gaia_source.solution_id IS 'Solution Identifier';
COMMENT ON COLUMN gaiadr3.gaia_source.designation IS 'Unique source designation (unique across all Data Releases)';
COMMENT ON COLUMN gaiadr3.gaia_source.source_id IS 'Unique source identifier (unique within a particular Data Release)';
COMMENT ON COLUMN gaiadr3.gaia_source.random_index IS 'Random index for use when selecting subsets';
COMMENT ON COLUMN gaiadr3.gaia_source.ref_epoch IS 'Reference epoch [yr]';
COMMENT ON COLUMN gaiadr3.gaia_source.ra IS 'Right ascension [deg]';
COMMENT ON COLUMN gaiadr3.gaia_source.ra_error IS 'Standard error of right ascension [mas]';
COMMENT ON COLUMN gaiadr3.gaia_source.dec IS 'Declination [deg]';
COMMENT ON COLUMN gaiadr3.gaia_source.dec_error IS 'Standard error of declination [mas]';
COMMENT ON COLUMN gaiadr3.gaia_source.parallax IS 'Parallax [mas]';
COMMENT ON COLUMN gaiadr3.gaia_source.parallax_error IS 'Standard error of parallax [mas]';
COMMENT ON COLUMN gaiadr3.gaia_source.parallax_over_error IS 'Parallax divided by its standard error';
COMMENT ON COLUMN gaiadr3.gaia_source.pm IS 'Total proper motion [mas.yr**-1]';
COMMENT ON COLUMN gaiadr3.gaia_source.pmra IS 'Proper motion in right ascension direction [mas.yr**-1]';
COMMENT ON COLUMN gaiadr3.gaia_source.pmra_error IS 'Standard error of proper motion in right ascension direction [mas.yr**-1]';
COMMENT ON COLUMN gaiadr3.gaia_source.pmdec IS 'Proper motion in declination direction [mas.yr**-1]';
COMMENT ON COLUMN gaiadr3.gaia_source.pmdec_error IS 'Standard error of proper motion in declination direction [mas.yr**-1]';
COMMENT ON COLUMN gaiadr3.gaia_source.ra_dec_corr IS 'Correlation between right ascension and declination';
COMMENT ON COLUMN gaiadr3.gaia_source.ra_parallax_corr IS 'Correlation between right ascension and parallax';
COMMENT ON COLUMN gaiadr3.gaia_source.ra_pmra_corr IS 'Correlation between right ascension and proper motion in right ascension';
COMMENT ON COLUMN gaiadr3.gaia_source.ra_pmdec_corr IS 'Correlation between right ascension and proper motion in declination';
COMMENT ON COLUMN gaiadr3.gaia_source.dec_parallax_corr IS 'Correlation between declination and parallax';
COMMENT ON COLUMN gaiadr3.gaia_source.dec_pmra_corr IS 'Correlation between declination and proper motion in right ascension';
COMMENT ON COLUMN gaiadr3.gaia_source.dec_pmdec_corr IS 'Correlation between declination and proper motion in declination';
COMMENT ON COLUMN gaiadr3.gaia_source.parallax_pmra_corr IS 'Correlation between parallax and proper motion in right ascension';
COMMENT ON COLUMN gaiadr3.gaia_source.parallax_pmdec_corr IS 'Correlation between parallax and proper motion in declination';
COMMENT ON COLUMN gaiadr3.gaia_source.pmra_pmdec_corr IS 'Correlation between proper motion in right ascension and proper motion in declination';
COMMENT ON COLUMN gaiadr3.gaia_source.astrometric_n_obs_al IS 'Total number of observations in the along-scan (AL) direction';
COMMENT ON COLUMN gaiadr3.gaia_source.astrometric_n_obs_ac IS 'Total number of observations in the across-scan (AC) direction';
COMMENT ON COLUMN gaiadr3.gaia_source.astrometric_n_good_obs_al IS 'Number of good observations in the along-scan (AL) direction';
COMMENT ON COLUMN gaiadr3.gaia_source.astrometric_n_bad_obs_al IS 'Number of bad observations in the along-scan (AL) direction';
COMMENT ON COLUMN gaiadr3.gaia_source.astrometric_gof_al IS 'Goodness of fit statistic of model wrt along-scan observations';
COMMENT ON COLUMN gaiadr3.gaia_source.astrometric_chi2_al IS 'AL chi-square value';
COMMENT ON COLUMN gaiadr3.gaia_source.astrometric_excess_noise IS 'Excess noise of the source [mas]';
COMMENT ON COLUMN gaiadr3.gaia_source.astrometric_excess_noise_sig IS 'Significance of excess noise';
COMMENT ON COLUMN gaiadr3.gaia_source.astrometric_params_solved IS 'Which parameters have been solved for?';
COMMENT ON COLUMN gaiadr3.gaia_source.astrometric_primary_flag IS 'Primary or seconday';
COMMENT ON COLUMN gaiadr3.gaia_source.nu_eff_used_in_astrometry IS 'Effective wavenumber of the source used in the astrometric solution [um**-1]';
COMMENT ON COLUMN gaiadr3.gaia_source.pseudocolour IS 'Astrometrically estimated pseudocolour of the source [um**-1]';
COMMENT ON COLUMN gaiadr3.gaia_source.pseudocolour_error IS 'Standard error of the pseudocolour of the source [um**-1]';
COMMENT ON COLUMN gaiadr3.gaia_source.ra_pseudocolour_corr IS 'Correlation between right ascension and pseudocolour';
COMMENT ON COLUMN gaiadr3.gaia_source.dec_pseudocolour_corr IS 'Correlation between declination and pseudocolour';
COMMENT ON COLUMN gaiadr3.gaia_source.parallax_pseudocolour_corr IS 'Correlation between parallax and pseudocolour';
COMMENT ON COLUMN gaiadr3.gaia_source.pmra_pseudocolour_corr IS 'Correlation between proper motion in right asension and pseudocolour';
COMMENT ON COLUMN gaiadr3.gaia_source.pmdec_pseudocolour_corr IS 'Correlation between proper motion in declination and pseudocolour';
COMMENT ON COLUMN gaiadr3.gaia_source.astrometric_matched_transits IS 'Matched FOV transits used in the AGIS solution';
COMMENT ON COLUMN gaiadr3.gaia_source.visibility_periods_used IS 'Number of visibility periods used in Astrometric solution';
COMMENT ON COLUMN gaiadr3.gaia_source.astrometric_sigma5d_max IS 'The longest semi-major axis of the 5-d error ellipsoid [mas]';
COMMENT ON COLUMN gaiadr3.gaia_source.matched_transits IS 'The number of transits matched to this source';
COMMENT ON COLUMN gaiadr3.gaia_source.new_matched_transits IS 'The number of transits newly incorporated into an existing source in the current cycle';
COMMENT ON COLUMN gaiadr3.gaia_source.matched_transits_removed IS 'The number of transits removed from an existing source in the current cycle';
COMMENT ON COLUMN gaiadr3.gaia_source.ipd_gof_harmonic_amplitude IS 'Amplitude of the IPD GoF versus position angle of scan';
COMMENT ON COLUMN gaiadr3.gaia_source.ipd_gof_harmonic_phase IS 'Phase of the IPD GoF versus position angle of scan [deg]';
COMMENT ON COLUMN gaiadr3.gaia_source.ipd_frac_multi_peak IS 'Percent of successful-IPD windows with more than one peak';
COMMENT ON COLUMN gaiadr3.gaia_source.ipd_frac_odd_win IS 'Percent of transits with truncated windows or multiple gate';
COMMENT ON COLUMN gaiadr3.gaia_source.ruwe IS 'Renormalised unit weight error';
COMMENT ON COLUMN gaiadr3.gaia_source.scan_direction_strength_k1 IS 'Degree of concentration of scan directions across the source';
COMMENT ON COLUMN gaiadr3.gaia_source.scan_direction_strength_k2 IS 'Degree of concentration of scan directions across the source';
COMMENT ON COLUMN gaiadr3.gaia_source.scan_direction_strength_k3 IS 'Degree of concentration of scan directions across the source';
COMMENT ON COLUMN gaiadr3.gaia_source.scan_direction_strength_k4 IS 'Degree of concentration of scan directions across the source';
COMMENT ON COLUMN gaiadr3.gaia_source.scan_direction_mean_k1 IS 'Mean position angle of scan directions across the source [deg]';
COMMENT ON COLUMN gaiadr3.gaia_source.scan_direction_mean_k2 IS 'Mean position angle of scan directions across the source [deg]';
COMMENT ON COLUMN gaiadr3.gaia_source.scan_direction_mean_k3 IS 'Mean position angle of scan directions across the source [deg]';
COMMENT ON COLUMN gaiadr3.gaia_source.scan_direction_mean_k4 IS 'Mean position angle of scan directions across the source [deg]';
COMMENT ON COLUMN gaiadr3.gaia_source.duplicated_source IS 'Source with multiple source identifiers';
COMMENT ON COLUMN gaiadr3.gaia_source.phot_g_n_obs IS 'Number of observations contributing to G photometry';
COMMENT ON COLUMN gaiadr3.gaia_source.phot_g_mean_flux IS 'G-band mean flux [''electron''.s**-1]';
COMMENT ON COLUMN gaiadr3.gaia_source.phot_g_mean_flux_error IS 'Error on G-band mean flux [''electron''.s**-1]';
COMMENT ON COLUMN gaiadr3.gaia_source.phot_g_mean_flux_over_error IS 'G-band mean flux divided by its error';
COMMENT ON COLUMN gaiadr3.gaia_source.phot_g_mean_mag IS 'G-band mean magnitude [mag]';
COMMENT ON COLUMN gaiadr3.gaia_source.phot_bp_n_obs IS 'Number of observations contributing to BP photometry';
COMMENT ON COLUMN gaiadr3.gaia_source.phot_bp_mean_flux IS 'Integrated BP mean flux [''electron''.s**-1]';
COMMENT ON COLUMN gaiadr3.gaia_source.phot_bp_mean_flux_error IS 'Error on the integrated BP mean flux [''electron''.s**-1]';
COMMENT ON COLUMN gaiadr3.gaia_source.phot_bp_mean_flux_over_error IS 'Integrated BP mean flux divided by its error';
COMMENT ON COLUMN gaiadr3.gaia_source.phot_bp_mean_mag IS 'Integrated BP mean magnitude [mag]';
COMMENT ON COLUMN gaiadr3.gaia_source.phot_rp_n_obs IS 'Number of observations contributing to RP photometry';
COMMENT ON COLUMN gaiadr3.gaia_source.phot_rp_mean_flux IS 'Integrated RP mean flux [''electron''.s**-1]';
COMMENT ON COLUMN gaiadr3.gaia_source.phot_rp_mean_flux_error IS 'Error on the integrated RP mean flux [''electron''.s**-1]';
COMMENT ON COLUMN gaiadr3.gaia_source.phot_rp_mean_flux_over_error IS 'Integrated RP mean flux divided by its error';
COMMENT ON COLUMN gaiadr3.gaia_source.phot_rp_mean_mag IS 'Integrated RP mean magnitude [mag]';
COMMENT ON COLUMN gaiadr3.gaia_source.phot_bp_rp_excess_factor IS 'BP/RP excess factor';
COMMENT ON COLUMN gaiadr3.gaia_source.phot_bp_n_contaminated_transits IS 'Number of BP contaminated transits';
COMMENT ON COLUMN gaiadr3.gaia_source.phot_bp_n_blended_transits IS 'Number of BP blended transits';
COMMENT ON COLUMN gaiadr3.gaia_source.phot_rp_n_contaminated_transits IS 'Number of RP contaminated transits';
COMMENT ON COLUMN gaiadr3.gaia_source.phot_rp_n_blended_transits IS 'Number of RP blended transits';
COMMENT ON COLUMN gaiadr3.gaia_source.phot_proc_mode IS 'Photometry processing mode';
COMMENT ON COLUMN gaiadr3.gaia_source.bp_rp IS 'BP - RP colour [mag]';
COMMENT ON COLUMN gaiadr3.gaia_source.bp_g IS 'BP - G colour [mag]';
COMMENT ON COLUMN gaiadr3.gaia_source.g_rp IS 'G - RP colour [mag]';
COMMENT ON COLUMN gaiadr3.gaia_source.radial_velocity IS 'Radial velocity [km.s**-1]';
COMMENT ON COLUMN gaiadr3.gaia_source.radial_velocity_error IS 'Radial velocity error [km.s**-1]';
COMMENT ON COLUMN gaiadr3.gaia_source.rv_method_used IS 'Method used to obtain the radial velocity';
COMMENT ON COLUMN gaiadr3.gaia_source.rv_nb_transits IS 'Number of transits used to compute the radial velocity';
COMMENT ON COLUMN gaiadr3.gaia_source.rv_nb_deblended_transits IS 'Number of valid transits that have undergone deblending';
COMMENT ON COLUMN gaiadr3.gaia_source.rv_visibility_periods_used IS 'Number of visibility periods used to estimate the radial velocity';
COMMENT ON COLUMN gaiadr3.gaia_source.rv_expected_sig_to_noise IS 'Expected signal to noise ratio in the combination of the spectra used to obtain the radial velocity';
COMMENT ON COLUMN gaiadr3.gaia_source.rv_renormalised_gof IS 'Radial velocity renormalised goodness of fit';
COMMENT ON COLUMN gaiadr3.gaia_source.rv_chisq_pvalue IS 'P-value for constancy based on a chi-squared criterion';
COMMENT ON COLUMN gaiadr3.gaia_source.rv_time_duration IS 'Time coverage of the radial velocity time series [d]';
COMMENT ON COLUMN gaiadr3.gaia_source.rv_amplitude_robust IS 'Total amplitude in the radial velocity time series after outlier removal [km.s**-1]';
COMMENT ON COLUMN gaiadr3.gaia_source.rv_template_teff IS 'Teff of the template used to compute the radial velocity [K]';
COMMENT ON COLUMN gaiadr3.gaia_source.rv_template_logg IS 'Logg of the template used to compute the radial velocity [log(cm.s**-2)]';
COMMENT ON COLUMN gaiadr3.gaia_source.rv_template_fe_h IS '[Fe/H] of the template used to compute the radial velocityy [''dex'']';
COMMENT ON COLUMN gaiadr3.gaia_source.rv_atm_param_origin IS 'Origin of the atmospheric parameters associated to the template';
COMMENT ON COLUMN gaiadr3.gaia_source.vbroad IS 'Spectral line broadening parameter [km.s**-1]';
COMMENT ON COLUMN gaiadr3.gaia_source.vbroad_error IS 'Uncertainty on the spectral line broadening [km.s**-1]';
COMMENT ON COLUMN gaiadr3.gaia_source.vbroad_nb_transits IS 'Number of transits used to compute vbroad';
COMMENT ON COLUMN gaiadr3.gaia_source.grvs_mag IS 'Integrated Grvs magnitude [mag]';
COMMENT ON COLUMN gaiadr3.gaia_source.grvs_mag_error IS 'Grvs magnitude uncertainty [mag]';
COMMENT ON COLUMN gaiadr3.gaia_source.grvs_mag_nb_transits IS 'Number of transits used to compute Grvs';
COMMENT ON COLUMN gaiadr3.gaia_source.rvs_spec_sig_to_noise IS 'Signal to noise ratio in the mean RVS spectrum';
COMMENT ON COLUMN gaiadr3.gaia_source.phot_variable_flag IS 'Photometric variability flag';
COMMENT ON COLUMN gaiadr3.gaia_source.l IS 'Galactic longitude [deg]';
COMMENT ON COLUMN gaiadr3.gaia_source.b IS 'Galactic latitude [deg]';
COMMENT ON COLUMN gaiadr3.gaia_source.ecl_lon IS 'Ecliptic longitude [deg]';
COMMENT ON COLUMN gaiadr3.gaia_source.ecl_lat IS 'Ecliptic latitude [deg]';
COMMENT ON COLUMN gaiadr3.gaia_source.in_qso_candidates IS 'Flag indicating the availability of additional information in the QSO candidates table';
COMMENT ON COLUMN gaiadr3.gaia_source.in_galaxy_candidates IS 'Flag indicating the availability of additional information in the galaxy candidates table';
COMMENT ON COLUMN gaiadr3.gaia_source.non_single_star IS 'Flag indicating the availability of additional information in the various Non-Single Star tables';
COMMENT ON COLUMN gaiadr3.gaia_source.has_xp_continuous IS 'Flag indicating the availability of mean BP/RP spectrum in continuous representation for this source';
COMMENT ON COLUMN gaiadr3.gaia_source.has_xp_sampled IS 'Flag indicating the availability of mean BP/RP spectrum in sampled form for this source';
COMMENT ON COLUMN gaiadr3.gaia_source.has_rvs IS 'Flag indicating the availability of mean RVS spectrum for this source';
COMMENT ON COLUMN gaiadr3.gaia_source.has_epoch_photometry IS 'Flag indicating the availability of epoch photometry for this source';
COMMENT ON COLUMN gaiadr3.gaia_source.has_epoch_rv IS 'Flag indicating the availability of epoch radial velocity for this source';
COMMENT ON COLUMN gaiadr3.gaia_source.has_mcmc_gspphot IS 'Flag indicating the availability of GSP-Phot MCMC samples for this source';
COMMENT ON COLUMN gaiadr3.gaia_source.has_mcmc_msc IS 'Flag indicating the availability of MSC MCMC samples for this source';
COMMENT ON COLUMN gaiadr3.gaia_source.in_andromeda_survey IS 'Flag indicating that the source is present in the Gaia Andromeda Photometric Survey (GAPS)';
COMMENT ON COLUMN gaiadr3.gaia_source.classprob_dsc_combmod_quasar IS 'Probability from DSC-Combmod of being a quasar (data used: BP/RP spectrum, photometry, astrometry)';
COMMENT ON COLUMN gaiadr3.gaia_source.classprob_dsc_combmod_galaxy IS 'Probability from DSC-Combmod of being a galaxy (data used: BP/RP spectrum, photometry, astrometry)';
COMMENT ON COLUMN gaiadr3.gaia_source.classprob_dsc_combmod_star IS 'Probability from DSC-Combmod of being a single star (but not a white dwarf) (data used: BP/RP spectrum, photometry, astrometry)';
COMMENT ON COLUMN gaiadr3.gaia_source.teff_gspphot IS 'Effective temperature from GSP-Phot Aeneas best library using BP/RP spectra [K]';
COMMENT ON COLUMN gaiadr3.gaia_source.teff_gspphot_lower IS 'Lower confidence level (16%) of effective temperature from GSP-Phot Aeneas best library using BP/RP spectra [K]';
COMMENT ON COLUMN gaiadr3.gaia_source.teff_gspphot_upper IS 'Upper confidence level (84%) of effective temperature from GSP-Phot Aeneas best library using BP/RP spectra [K]';
COMMENT ON COLUMN gaiadr3.gaia_source.logg_gspphot IS 'Surface gravity from GSP-Phot Aeneas best library using BP/RP spectra [log(cm.s**-2)]';
COMMENT ON COLUMN gaiadr3.gaia_source.logg_gspphot_lower IS 'Lower confidence level (16%) of surface gravity from GSP-Phot Aeneas best library using BP/RP spectra [log(cm.s**-2)]';
COMMENT ON COLUMN gaiadr3.gaia_source.logg_gspphot_upper IS 'Upper confidence level (84%) of surface gravity from GSP-Phot Aeneas best library using BP/RP spectra [log(cm.s**-2)]';
COMMENT ON COLUMN gaiadr3.gaia_source.mh_gspphot IS 'Iron abundance from GSP-Phot Aeneas best library using BP/RP spectra [''dex'']';
COMMENT ON COLUMN gaiadr3.gaia_source.mh_gspphot_lower IS 'Lower confidence level (16%) of iron abundance from GSP-Phot Aeneas best library using BP/RP spectra [''dex'']';
COMMENT ON COLUMN gaiadr3.gaia_source.mh_gspphot_upper IS 'Upper confidence level (84%) of iron abundance from GSP-Phot Aeneas best library using BP/RP spectra [''dex'']';
COMMENT ON COLUMN gaiadr3.gaia_source.distance_gspphot IS 'Distance from GSP-Phot Aeneas best library using BP/RP spectra [pc]';
COMMENT ON COLUMN gaiadr3.gaia_source.distance_gspphot_lower IS 'Lower confidence level (16%) of distance from GSP-Phot Aeneas best library using BP/RP spectra [pc]';
COMMENT ON COLUMN gaiadr3.gaia_source.distance_gspphot_upper IS 'Upper confidence level (84%) of distance from GSP-Phot Aeneas best library using BP/RP spectra [pc]';
COMMENT ON COLUMN gaiadr3.gaia_source.azero_gspphot IS 'Monochromatic extinction $A_0$ at 547.7nm from GSP-Phot Aeneas best library using BP/RP spectra [mag]';
COMMENT ON COLUMN gaiadr3.gaia_source.azero_gspphot_lower IS 'Lower confidence level (16%) of monochromatic extinction $A_0$ at 547.7nm from GSP-Phot Aeneas best library using BP/RP spectra [mag]';
COMMENT ON COLUMN gaiadr3.gaia_source.azero_gspphot_upper IS 'Upper confidence level (84%) of monochromatic extinction $A_0$ at 547.7nm from GSP-Phot Aeneas best library using BP/RP spectra [mag]';
COMMENT ON COLUMN gaiadr3.gaia_source.ag_gspphot IS 'Extinction in G band from GSP-Phot Aeneas best library using BP/RP spectra [mag]';
COMMENT ON COLUMN gaiadr3.gaia_source.ag_gspphot_lower IS 'Lower confidence level (16%) of extinction in G band from GSP-Phot Aeneas best library using BP/RP spectra [mag]';
COMMENT ON COLUMN gaiadr3.gaia_source.ag_gspphot_upper IS 'Upper confidence level (84%) of extinction in G band from GSP-Phot Aeneas best library using BP/RP spectra [mag]';
COMMENT ON COLUMN gaiadr3.gaia_source.ebpminrp_gspphot IS 'Reddening $E(G_{\rm BP} - G_{\rm RP})$ from GSP-Phot Aeneas best library using BP/RP spectra [mag]';
COMMENT ON COLUMN gaiadr3.gaia_source.ebpminrp_gspphot_lower IS 'Lower confidence level (16%) of reddening $E(G_{\rm BP} - G_{\rm RP})$ from GSP-Phot Aeneas best library using BP/RP spectra [mag]';
COMMENT ON COLUMN gaiadr3.gaia_source.ebpminrp_gspphot_upper IS 'Upper confidence level (84%) of reddening $E(G_{\rm BP} - G_{\rm RP})$ from GSP-Phot Aeneas best library using BP/RP spectra [mag]';
COMMENT ON COLUMN gaiadr3.gaia_source.libname_gspphot IS 'Name of library that achieves the highest mean log-posterior in MCMC samples and was used to derive GSP-Phot parameters in this table';
CREATE INDEX IF NOT EXISTS gaiadr3_gaia_source_source_id_idx ON gaiadr3.gaia_source (source_id);

-- [Catálogo principal] gaiadr3.gaia_source_lite — acceso: TAP Gaia (ADQL)
CREATE TABLE IF NOT EXISTS gaiadr3.gaia_source_lite (
    source_id bigint,
    random_index bigint,
    ra double precision,
    dec double precision,
    parallax double precision,
    parallax_error real,
    parallax_over_error real,
    pmra double precision,
    pmra_error real,
    pmdec double precision,
    pmdec_error real,
    astrometric_params_solved smallint,
    pseudocolour real,
    pseudocolour_error real,
    ipd_frac_multi_peak smallint,
    ipd_frac_odd_win smallint,
    ruwe real,
    phot_g_mean_flux_over_error real,
    phot_g_mean_mag real,
    phot_bp_mean_flux_over_error real,
    phot_bp_mean_mag real,
    phot_rp_mean_flux_over_error real,
    phot_rp_mean_mag real,
    phot_bp_rp_excess_factor real,
    bp_rp real,
    radial_velocity real,
    radial_velocity_error real,
    rv_nb_transits smallint,
    rv_expected_sig_to_noise real,
    rv_renormalised_gof real,
    rv_chisq_pvalue real,
    phot_variable_flag text,
    l double precision,
    b double precision,
    in_qso_candidates boolean,
    in_galaxy_candidates boolean,
    non_single_star smallint,
    has_xp_continuous boolean,
    has_xp_sampled boolean,
    has_rvs boolean,
    has_epoch_photometry boolean,
    has_epoch_rv boolean,
    has_mcmc_gspphot boolean,
    has_mcmc_msc boolean,
    in_andromeda_survey boolean,
    teff_gspphot real,
    logg_gspphot real,
    mh_gspphot real,
    distance_gspphot real,
    ag_gspphot real,
    ebpminrp_gspphot real
);
COMMENT ON TABLE gaiadr3.gaia_source_lite IS 'This is a column-wise subset of the gaia_source table named gaia_source_lite. This table has an entry for every Gaia observed source as published with this data release. It contains the basic source parameters, in their final state as processed by the Gaia Data Processing and Analysis Consortium from the raw data coming from the spacecraft. The table is complemented with others containing information specific to certain kinds of objects (e.g.~Solar--system objects, non--single stars, variables etc.) and value--added processing (e.g.~astrophysical parameters etc.). Further array data types (spectra, epoch measurements) are presented separately via Datalink resources.';
COMMENT ON COLUMN gaiadr3.gaia_source_lite.source_id IS 'Unique source identifier (unique within a particular Data Release)';
COMMENT ON COLUMN gaiadr3.gaia_source_lite.random_index IS 'Random index for use when selecting subsets';
COMMENT ON COLUMN gaiadr3.gaia_source_lite.ra IS 'Right ascension [deg]';
COMMENT ON COLUMN gaiadr3.gaia_source_lite.dec IS 'Declination [deg]';
COMMENT ON COLUMN gaiadr3.gaia_source_lite.parallax IS 'Parallax [mas]';
COMMENT ON COLUMN gaiadr3.gaia_source_lite.parallax_error IS 'Standard error of parallax [mas]';
COMMENT ON COLUMN gaiadr3.gaia_source_lite.parallax_over_error IS 'Parallax divided by its standard error';
COMMENT ON COLUMN gaiadr3.gaia_source_lite.pmra IS 'Proper motion in right ascension direction [mas.yr**-1]';
COMMENT ON COLUMN gaiadr3.gaia_source_lite.pmra_error IS 'Standard error of proper motion in right ascension direction [mas.yr**-1]';
COMMENT ON COLUMN gaiadr3.gaia_source_lite.pmdec IS 'Proper motion in declination direction [mas.yr**-1]';
COMMENT ON COLUMN gaiadr3.gaia_source_lite.pmdec_error IS 'Standard error of proper motion in declination direction [mas.yr**-1]';
COMMENT ON COLUMN gaiadr3.gaia_source_lite.astrometric_params_solved IS 'Which parameters have been solved for?';
COMMENT ON COLUMN gaiadr3.gaia_source_lite.pseudocolour IS 'Astrometrically estimated pseudocolour of the source [um**-1]';
COMMENT ON COLUMN gaiadr3.gaia_source_lite.pseudocolour_error IS 'Standard error of the pseudocolour of the source [um**-1]';
COMMENT ON COLUMN gaiadr3.gaia_source_lite.ipd_frac_multi_peak IS 'Percent of successful-IPD windows with more than one peak';
COMMENT ON COLUMN gaiadr3.gaia_source_lite.ipd_frac_odd_win IS 'Percent of transits with truncated windows or multiple gate';
COMMENT ON COLUMN gaiadr3.gaia_source_lite.ruwe IS 'Renormalised unit weight error';
COMMENT ON COLUMN gaiadr3.gaia_source_lite.phot_g_mean_flux_over_error IS 'G-band mean flux divided by its error';
COMMENT ON COLUMN gaiadr3.gaia_source_lite.phot_g_mean_mag IS 'G-band mean magnitude [mag]';
COMMENT ON COLUMN gaiadr3.gaia_source_lite.phot_bp_mean_flux_over_error IS 'Integrated BP mean flux divided by its error';
COMMENT ON COLUMN gaiadr3.gaia_source_lite.phot_bp_mean_mag IS 'Integrated BP mean magnitude [mag]';
COMMENT ON COLUMN gaiadr3.gaia_source_lite.phot_rp_mean_flux_over_error IS 'Integrated RP mean flux divided by its error';
COMMENT ON COLUMN gaiadr3.gaia_source_lite.phot_rp_mean_mag IS 'Integrated RP mean magnitude [mag]';
COMMENT ON COLUMN gaiadr3.gaia_source_lite.phot_bp_rp_excess_factor IS 'BP/RP excess factor';
COMMENT ON COLUMN gaiadr3.gaia_source_lite.bp_rp IS 'BP - RP colour [mag]';
COMMENT ON COLUMN gaiadr3.gaia_source_lite.radial_velocity IS 'Radial velocity [km.s**-1]';
COMMENT ON COLUMN gaiadr3.gaia_source_lite.radial_velocity_error IS 'Radial velocity error [km.s**-1]';
COMMENT ON COLUMN gaiadr3.gaia_source_lite.rv_nb_transits IS 'Number of transits used to compute the radial velocity';
COMMENT ON COLUMN gaiadr3.gaia_source_lite.rv_expected_sig_to_noise IS 'Expected signal to noise ratio in the combination of the spectra used to obtain the radial velocity';
COMMENT ON COLUMN gaiadr3.gaia_source_lite.rv_renormalised_gof IS 'Radial velocity renormalised goodness of fit';
COMMENT ON COLUMN gaiadr3.gaia_source_lite.rv_chisq_pvalue IS 'P-value for constancy based on a chi-squared criterion';
COMMENT ON COLUMN gaiadr3.gaia_source_lite.phot_variable_flag IS 'Photometric variability flag';
COMMENT ON COLUMN gaiadr3.gaia_source_lite.l IS 'Galactic longitude [deg]';
COMMENT ON COLUMN gaiadr3.gaia_source_lite.b IS 'Galactic latitude [deg]';
COMMENT ON COLUMN gaiadr3.gaia_source_lite.in_qso_candidates IS 'Flag indicating the availability of additional information in the QsoCandidates table';
COMMENT ON COLUMN gaiadr3.gaia_source_lite.in_galaxy_candidates IS 'Flag indicating the availability of additional information in the GalaxyCandidates table';
COMMENT ON COLUMN gaiadr3.gaia_source_lite.non_single_star IS 'Flag indicating the availability of additional information in the various Non-Single Star tables';
COMMENT ON COLUMN gaiadr3.gaia_source_lite.has_xp_continuous IS 'Flag indicating the availability of mean BP/RP spectrum in continuous representation for this source';
COMMENT ON COLUMN gaiadr3.gaia_source_lite.has_xp_sampled IS 'Flag indicating the availability of mean BP/RP spectrum in sampled form for this source';
COMMENT ON COLUMN gaiadr3.gaia_source_lite.has_rvs IS 'Flag indicating the availability of mean RVS spectrum for this source';
COMMENT ON COLUMN gaiadr3.gaia_source_lite.has_epoch_photometry IS 'Flag indicating the availability of epoch photometry for this source';
COMMENT ON COLUMN gaiadr3.gaia_source_lite.has_epoch_rv IS 'Flag indicating the availability of epoch radial velocity for this source';
COMMENT ON COLUMN gaiadr3.gaia_source_lite.has_mcmc_gspphot IS 'Flag indicating the availability of GSP-Phot MCMC samples for this source';
COMMENT ON COLUMN gaiadr3.gaia_source_lite.has_mcmc_msc IS 'Flag indicating the availability of MSC MCMC samples for this source';
COMMENT ON COLUMN gaiadr3.gaia_source_lite.in_andromeda_survey IS 'Flag indicating that the source is present in the Gaia Andromeda Photometric Survey (GAPS)';
COMMENT ON COLUMN gaiadr3.gaia_source_lite.teff_gspphot IS 'Effective temperature from GSP-Phot Aeneas best library using BP/RP spectra [K]';
COMMENT ON COLUMN gaiadr3.gaia_source_lite.logg_gspphot IS 'Surface gravity from GSP-Phot Aeneas best library using BP/RP,spectra [log(cm.s**-2)]';
COMMENT ON COLUMN gaiadr3.gaia_source_lite.mh_gspphot IS 'Iron abundance from GSP-Phot Aeneas best library using BP/RP spectra [''dex'']';
COMMENT ON COLUMN gaiadr3.gaia_source_lite.distance_gspphot IS 'Distance from GSP-Phot Aeneas best library using BP/RP spectra [pc]';
COMMENT ON COLUMN gaiadr3.gaia_source_lite.ag_gspphot IS 'Extinction in G band from GSP-Phot Aeneas best library using BP/RP spectra [mag]';
COMMENT ON COLUMN gaiadr3.gaia_source_lite.ebpminrp_gspphot IS 'Reddening $E(G_{\rm BP} - G_{\rm RP})$ from GSP-Phot Aeneas best library using BP/RP spectra [mag]';
CREATE INDEX IF NOT EXISTS gaiadr3_gaia_source_lite_source_id_idx ON gaiadr3.gaia_source_lite (source_id);

-- [Parámetros astrofísicos] gaiadr3.astrophysical_parameters — acceso: TAP Gaia (ADQL)
CREATE TABLE IF NOT EXISTS gaiadr3.astrophysical_parameters (
    solution_id bigint,
    source_id bigint,
    classprob_dsc_combmod_quasar real,
    classprob_dsc_combmod_galaxy real,
    classprob_dsc_combmod_star real,
    classprob_dsc_combmod_whitedwarf real,
    classprob_dsc_combmod_binarystar real,
    classprob_dsc_specmod_quasar real,
    classprob_dsc_specmod_galaxy real,
    classprob_dsc_specmod_star real,
    classprob_dsc_specmod_whitedwarf real,
    classprob_dsc_specmod_binarystar real,
    classprob_dsc_allosmod_quasar real,
    classprob_dsc_allosmod_galaxy real,
    classprob_dsc_allosmod_star real,
    teff_gspphot real,
    teff_gspphot_lower real,
    teff_gspphot_upper real,
    logg_gspphot real,
    logg_gspphot_lower real,
    logg_gspphot_upper real,
    mh_gspphot real,
    mh_gspphot_lower real,
    mh_gspphot_upper real,
    distance_gspphot real,
    distance_gspphot_lower real,
    distance_gspphot_upper real,
    azero_gspphot real,
    azero_gspphot_lower real,
    azero_gspphot_upper real,
    ag_gspphot real,
    ag_gspphot_lower real,
    ag_gspphot_upper real,
    abp_gspphot real,
    abp_gspphot_lower real,
    abp_gspphot_upper real,
    arp_gspphot real,
    arp_gspphot_lower real,
    arp_gspphot_upper real,
    ebpminrp_gspphot real,
    ebpminrp_gspphot_lower real,
    ebpminrp_gspphot_upper real,
    mg_gspphot real,
    mg_gspphot_lower real,
    mg_gspphot_upper real,
    radius_gspphot real,
    radius_gspphot_lower real,
    radius_gspphot_upper real,
    logposterior_gspphot real,
    mcmcaccept_gspphot real,
    libname_gspphot text,
    teff_gspspec real,
    teff_gspspec_lower real,
    teff_gspspec_upper real,
    logg_gspspec real,
    logg_gspspec_lower real,
    logg_gspspec_upper real,
    mh_gspspec real,
    mh_gspspec_lower real,
    mh_gspspec_upper real,
    alphafe_gspspec real,
    alphafe_gspspec_lower real,
    alphafe_gspspec_upper real,
    fem_gspspec real,
    fem_gspspec_lower real,
    fem_gspspec_upper real,
    fem_gspspec_nlines integer,
    fem_gspspec_linescatter real,
    sife_gspspec real,
    sife_gspspec_lower real,
    sife_gspspec_upper real,
    sife_gspspec_nlines integer,
    sife_gspspec_linescatter real,
    cafe_gspspec real,
    cafe_gspspec_lower real,
    cafe_gspspec_upper real,
    cafe_gspspec_nlines integer,
    cafe_gspspec_linescatter real,
    tife_gspspec real,
    tife_gspspec_lower real,
    tife_gspspec_upper real,
    tife_gspspec_nlines integer,
    tife_gspspec_linescatter real,
    mgfe_gspspec real,
    mgfe_gspspec_lower real,
    mgfe_gspspec_upper real,
    mgfe_gspspec_nlines integer,
    mgfe_gspspec_linescatter real,
    ndfe_gspspec real,
    ndfe_gspspec_lower real,
    ndfe_gspspec_upper real,
    ndfe_gspspec_nlines integer,
    ndfe_gspspec_linescatter real,
    feiim_gspspec real,
    feiim_gspspec_lower real,
    feiim_gspspec_upper real,
    feiim_gspspec_nlines integer,
    feiim_gspspec_linescatter real,
    sfe_gspspec real,
    sfe_gspspec_lower real,
    sfe_gspspec_upper real,
    sfe_gspspec_nlines integer,
    sfe_gspspec_linescatter real,
    zrfe_gspspec real,
    zrfe_gspspec_lower real,
    zrfe_gspspec_upper real,
    zrfe_gspspec_nlines integer,
    zrfe_gspspec_linescatter real,
    nfe_gspspec real,
    nfe_gspspec_lower real,
    nfe_gspspec_upper real,
    nfe_gspspec_nlines integer,
    nfe_gspspec_linescatter real,
    crfe_gspspec real,
    crfe_gspspec_lower real,
    crfe_gspspec_upper real,
    crfe_gspspec_nlines integer,
    crfe_gspspec_linescatter real,
    cefe_gspspec real,
    cefe_gspspec_lower real,
    cefe_gspspec_upper real,
    cefe_gspspec_nlines integer,
    cefe_gspspec_linescatter real,
    nife_gspspec real,
    nife_gspspec_lower real,
    nife_gspspec_upper real,
    nife_gspspec_nlines integer,
    nife_gspspec_linescatter real,
    cn0ew_gspspec real,
    cn0ew_gspspec_uncertainty real,
    cn0_gspspec_centralline real,
    cn0_gspspec_width real,
    dib_gspspec_lambda real,
    dib_gspspec_lambda_uncertainty real,
    dibew_gspspec real,
    dibew_gspspec_uncertainty real,
    dibewnoise_gspspec_uncertainty real,
    dibp0_gspspec real,
    dibp2_gspspec real,
    dibp2_gspspec_uncertainty real,
    dibqf_gspspec integer,
    flags_gspspec text,
    logchisq_gspspec real,
    ew_espels_halpha real,
    ew_espels_halpha_uncertainty real,
    ew_espels_halpha_flag text,
    ew_espels_halpha_model real,
    classlabel_espels text,
    classlabel_espels_flag text,
    classprob_espels_wcstar real,
    classprob_espels_wnstar real,
    classprob_espels_bestar real,
    classprob_espels_ttauristar real,
    classprob_espels_herbigstar real,
    classprob_espels_dmestar real,
    classprob_espels_pne real,
    azero_esphs real,
    azero_esphs_uncertainty real,
    ag_esphs real,
    ag_esphs_uncertainty real,
    ebpminrp_esphs real,
    ebpminrp_esphs_uncertainty real,
    teff_esphs real,
    teff_esphs_uncertainty real,
    logg_esphs real,
    logg_esphs_uncertainty real,
    vsini_esphs real,
    vsini_esphs_uncertainty real,
    flags_esphs text,
    spectraltype_esphs text,
    activityindex_espcs real,
    activityindex_espcs_uncertainty real,
    activityindex_espcs_input text,
    teff_espucd real,
    teff_espucd_uncertainty real,
    flags_espucd text,
    radius_flame real,
    radius_flame_lower real,
    radius_flame_upper real,
    lum_flame real,
    lum_flame_lower real,
    lum_flame_upper real,
    mass_flame real,
    mass_flame_lower real,
    mass_flame_upper real,
    age_flame real,
    age_flame_lower real,
    age_flame_upper real,
    flags_flame text,
    evolstage_flame integer,
    gravredshift_flame real,
    gravredshift_flame_lower real,
    gravredshift_flame_upper real,
    bc_flame real,
    mh_msc real,
    mh_msc_upper real,
    mh_msc_lower real,
    azero_msc real,
    azero_msc_upper real,
    azero_msc_lower real,
    distance_msc real,
    distance_msc_upper real,
    distance_msc_lower real,
    teff_msc1 real,
    teff_msc1_upper real,
    teff_msc1_lower real,
    teff_msc2 real,
    teff_msc2_upper real,
    teff_msc2_lower real,
    logg_msc1 real,
    logg_msc1_upper real,
    logg_msc1_lower real,
    logg_msc2 real,
    logg_msc2_upper real,
    logg_msc2_lower real,
    ag_msc real,
    ag_msc_upper real,
    ag_msc_lower real,
    logposterior_msc real,
    mcmcaccept_msc real,
    mcmcdrift_msc real,
    flags_msc text,
    neuron_oa_id bigint,
    neuron_oa_dist real,
    neuron_oa_dist_percentile_rank integer,
    flags_oa text
);
COMMENT ON TABLE gaiadr3.astrophysical_parameters IS 'This is the main table containing the 1D astrophysical parameters produced by the Apsis processing chain developed in Gaia DPAC CU8 (see Chapter~\ref{chap:cu8par}). Additional parameters can be found in table {\tt AstrophysicalParametersSupp}.';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.solution_id IS 'Solution Identifier';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.source_id IS 'Source Identifier';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.classprob_dsc_combmod_quasar IS 'Probability from DSC-Combmod of being a quasar (data used: BP/RP spectrum, photometry, astrometry)';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.classprob_dsc_combmod_galaxy IS 'Probability from DSC-Combmod of being a galaxy (data used: BP/RP spectrum, photometry, astrometry)';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.classprob_dsc_combmod_star IS 'Probability from DSC-Combmod of being a single star (but not a white dwarf) (data used: BP/RP spectrum, photometry, astrometry)';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.classprob_dsc_combmod_whitedwarf IS 'Probability from DSC-Combmod of being a white dwarf (data used: BP/RP spectrum, photometry, astrometry)';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.classprob_dsc_combmod_binarystar IS 'Probability from DSC-Combmod of being a binary star (data used: BP/RP spectrum, photometry, astrometry)';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.classprob_dsc_specmod_quasar IS 'Probability from DSC-Specmod of being a quasar (data used: BP/RP spectrum)';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.classprob_dsc_specmod_galaxy IS 'Probability from DSC-Specmod of being a galaxy (data used: BP/RP spectrum)';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.classprob_dsc_specmod_star IS 'Probability from DSC-Specmod of being a single star (but not a white dwarf) (data used: BP/RP spectrum)';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.classprob_dsc_specmod_whitedwarf IS 'Probability from DSC-Specmod of being a white dwarf (data used: BP/RP spectrum)';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.classprob_dsc_specmod_binarystar IS 'Probability from DSC-Specmod of being a binary star (data used: BP/RP spectrum)';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.classprob_dsc_allosmod_quasar IS 'Probability from DSC-Allosmod of being a quasar (data used: photometry, astrometry)';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.classprob_dsc_allosmod_galaxy IS 'Probability from DSC-Allosmod of being a galaxy (data used: photometry, astrometry)';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.classprob_dsc_allosmod_star IS 'Probability from DSC-Allosmod of being a star (data used: photometry, astrometry)';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.teff_gspphot IS 'Effective temperature from GSP-Phot Aeneas best library using BP/RP spectra [K]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.teff_gspphot_lower IS 'Lower confidence level (16%) of effective temperature from GSP-Phot Aeneas best library using BP/RP spectra [K]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.teff_gspphot_upper IS 'Upper confidence level (84%) of effective temperature from GSP-Phot Aeneas best library using BP/RP spectra [K]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.logg_gspphot IS 'Surface gravity from GSP-Phot Aeneas best library using BP/RP spectra [log(cm.s**-2)]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.logg_gspphot_lower IS 'Lower confidence level (16%) of surface gravity from GSP-Phot Aeneas best library using BP/RP spectra [log(cm.s**-2)]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.logg_gspphot_upper IS 'Upper confidence level (84%) of surface gravity from GSP-Phot Aeneas best library using BP/RP spectra [log(cm.s**-2)]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.mh_gspphot IS 'Iron abundance from GSP-Phot Aeneas best library using BP/RP spectra [''dex'']';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.mh_gspphot_lower IS 'Lower confidence level (16%) of iron abundance from GSP-Phot Aeneas best library using BP/RP spectra [''dex'']';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.mh_gspphot_upper IS 'Upper confidence level (84%) of iron abundance from GSP-Phot Aeneas best library using BP/RP spectra [''dex'']';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.distance_gspphot IS 'Distance from GSP-Phot Aeneas best library using BP/RP spectra [pc]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.distance_gspphot_lower IS 'Lower confidence level (16%) of distance from GSP-Phot Aeneas best library using BP/RP spectra [pc]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.distance_gspphot_upper IS 'Upper confidence level (84%) of distance from GSP-Phot Aeneas best library using BP/RP spectra [pc]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.azero_gspphot IS 'Monochromatic extinction $A_0$ at 547.7nm from GSP-Phot Aeneas best library using BP/RP spectra [mag]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.azero_gspphot_lower IS 'Lower confidence level (16%) of monochromatic extinction $A_0$ at 547.7nm from GSP-Phot Aeneas best library using BP/RP spectra [mag]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.azero_gspphot_upper IS 'Upper confidence level (84%) of monochromatic extinction $A_0$ at 547.7nm from GSP-Phot Aeneas best library using BP/RP spectra [mag]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.ag_gspphot IS 'Extinction in G band from GSP-Phot Aeneas best library using BP/RP spectra [mag]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.ag_gspphot_lower IS 'Lower confidence level (16%) of extinction in G band from GSP-Phot Aeneas best library using BP/RP spectra [mag]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.ag_gspphot_upper IS 'Upper confidence level (84%) of extinction in G band from GSP-Phot Aeneas best library using BP/RP spectra [mag]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.abp_gspphot IS 'Extinction in $G_{\rm BP}$ band from GSP-Phot Aeneas best library using BP/RP spectra [mag]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.abp_gspphot_lower IS 'Lower confidence level (16%) of extinction in $G_{\rm BP}$ band from GSP-Phot Aeneas best library using BP/RP spectra [mag]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.abp_gspphot_upper IS 'Upper confidence level (84%) of extinction in $G_{\rm BP}$ band from GSP-Phot Aeneas best library using BP/RP spectra [mag]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.arp_gspphot IS 'Extinction in $G_{\rm RP}$ band from GSP-Phot Aeneas best library using BP/RP spectra [mag]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.arp_gspphot_lower IS 'Lower confidence level (16%) of extinction in $G_{\rm RP}$ band from GSP-Phot Aeneas best library using BP/RP spectra [mag]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.arp_gspphot_upper IS 'Upper confidence level (84%) of extinction in $G_{\rm RP}$ band from GSP-Phot Aeneas best library using BP/RP spectra [mag]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.ebpminrp_gspphot IS 'Reddening $E(G_{\rm BP} - G_{\rm RP})$ from GSP-Phot Aeneas best library using BP/RP spectra [mag]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.ebpminrp_gspphot_lower IS 'Lower confidence level (16%) of reddening $E(G_{\rm BP} - G_{\rm RP})$ from GSP-Phot Aeneas best library using BP/RP spectra [mag]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.ebpminrp_gspphot_upper IS 'Upper confidence level (84%) of reddening $E(G_{\rm BP} - G_{\rm RP})$ from GSP-Phot Aeneas best library using BP/RP spectra [mag]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.mg_gspphot IS 'Absolute magnitude $M_{\rm G}$ from GSP-Phot Aeneas best library using BP/RP spectra [mag]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.mg_gspphot_lower IS 'Lower confidence level (16%) of absolute magnitude $M_{\rm G}$ from GSP-Phot Aeneas best library using BP/RP spectra [mag]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.mg_gspphot_upper IS 'Upper confidence level (84%) of absolute magnitude $M_{\rm G}$ from GSP-Phot Aeneas best library using BP/RP spectra [mag]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.radius_gspphot IS 'Radius from GSP-Phot Aeneas best library using BP/RP spectra [solRad]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.radius_gspphot_lower IS 'Lower confidence level (16%) of radius from GSP-Phot Aeneas best library using BP/RP spectra [solRad]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.radius_gspphot_upper IS 'Upper confidence level (84%) of radius from GSP-Phot Aeneas best library using BP/RP spectra [solRad]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.logposterior_gspphot IS 'Goodness-of-fit score (mean log-posterior of MCMC) of GSP-Phot Aeneas MCMC best library';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.mcmcaccept_gspphot IS 'MCMC acceptance rate of GSP-Phot Aeneas MCMC best library';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.libname_gspphot IS 'Name of library that achieves the highest mean log-posterior in MCMC samples and was used to derive GSP-Phot parameters in this table';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.teff_gspspec IS 'Effective temperature from GSP-Spec MatisseGauguin using RVS spectra and Monte Carlo realisations [K]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.teff_gspspec_lower IS '16th percentile of effective temperature from GSP-Spec MatisseGauguin using RVS spectra and Monte Carlo realisations [K]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.teff_gspspec_upper IS '84th percentile of effective temperature from GSP-Spec MatisseGauguin using RVS spectra and Monte Carlo realisations [K]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.logg_gspspec IS 'Logarithm of the stellar surface gravity from GSP-Spec MatisseGauguin using RVS spectra and Monte Carlo realisations [log(cm.s**-2)]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.logg_gspspec_lower IS '16th percentile of the logarithm of the stellar surface gravity from GSP-Spec MatisseGauguin using RVS spectra and Monte Carlo realisations [log(cm.s**-2)]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.logg_gspspec_upper IS '84th percentile of the logarithm of the stellar surface gravity from GSP-Spec MatisseGauguin using RVS spectra and Monte Carlo realisations [log(cm.s**-2)]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.mh_gspspec IS 'Global metallicity [M/H] from GSP-Spec MatisseGauguin using RVS spectra and Monte Carlo realisations [''dex'']';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.mh_gspspec_lower IS '16th percentile of global metallicity [M/H] from GSP-Spec MatisseGauguin using RVS spectra and Monte Carlo realisations [''dex'']';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.mh_gspspec_upper IS '84th percentile of global metallicity [M/H] from GSP-Spec MatisseGauguin using RVS spectra and Monte Carlo realisations [''dex'']';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.alphafe_gspspec IS 'Abundance of alpha-elements [alpha/Fe] with respect to iron from GSP-Spec MatisseGauguin using RVS spectra and Monte Carlo realisations [''dex'']';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.alphafe_gspspec_lower IS '16th percentile of the abundance of alpha-elements [alpha/Fe] with respect to iron from GSP-Spec MatisseGauguin using RVS spectra and Monte Carlo realisations [''dex'']';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.alphafe_gspspec_upper IS '84th percentile of the abundance of alpha-elements [alpha/Fe] with respect to iron from GSP-Spec MatisseGauguin using RVS spectra and Monte Carlo realisations [''dex'']';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.fem_gspspec IS 'Abundance of neutral iron [Fe/M] from GSP-Spec MatisseGauguin using RVS spectra and Monte Carlo realisations, applied to the individual N lines of the element, given in {\tt femGspspecNlines} [''dex'']';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.fem_gspspec_lower IS '16th percentile of the abundance of neutral iron [Fe/M] from GSP-Spec MatisseGauguin using RVS spectra and Monte Carlo realisations [''dex'']';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.fem_gspspec_upper IS '84th percentile of the abundance of neutral iron [Fe/M] from GSP-Spec MatisseGauguin using RVS spectra and Monte Carlo realisations [''dex'']';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.fem_gspspec_nlines IS 'Number of lines used for [Fe/M] abundance estimation';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.fem_gspspec_linescatter IS 'Uncertainty estimation of [Fe/M] abundance using N lines of the element, given in {\tt femGspspecNlines} [''dex'']';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.sife_gspspec IS 'Abundance of Silicon [Si/Fe] from GSP-Spec MatisseGauguin using RVS spectra and Monte Carlo realisations, applied to the individual N lines of the element, given in {\tt sifeGspspecNlines} [''dex'']';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.sife_gspspec_lower IS '16th percentile of the abundance of silicon [Si/Fe] from GSP-Spec MatisseGauguin using RVS spectra and Monte Carlo realisations [''dex'']';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.sife_gspspec_upper IS '84th percentile of the abundance of silicon [Si/Fe] from GSP-Spec MatisseGauguin using RVS spectra and Monte Carlo realisations [''dex'']';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.sife_gspspec_nlines IS 'Number of lines used for [Si/Fe] abundance estimation';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.sife_gspspec_linescatter IS 'Uncertainty estimation of [Si/Fe] abundance using N lines of the element, given in {\tt sifeGspspecNlines} [''dex'']';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.cafe_gspspec IS 'Abundance of Calcium [Ca/Fe] from GSP-Spec MatisseGauguin using RVS spectra and Monte Carlo realisations, applied to the individual N lines of the element, given in {\tt cafeGspspecNlines} [''dex'']';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.cafe_gspspec_lower IS '16th percentile of the abundance of Calcium [Ca/Fe] from GSP-Spec MatisseGauguin using RVS spectra and Monte Carlo realisations [''dex'']';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.cafe_gspspec_upper IS '84th percentile of the abundance of Calcium [Ca/Fe] from GSP-Spec MatisseGauguin using RVS spectra and Monte Carlo realisations [''dex'']';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.cafe_gspspec_nlines IS 'Number of lines used for [Ca/Fe] abundance estimation';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.cafe_gspspec_linescatter IS 'Uncertainty estimation of [Ca/Fe] abundance using N lines of the element, given in {\tt cafeGspspecNlines} [''dex'']';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.tife_gspspec IS 'Abundance of Titanium [Ti/Fe] from GSP-Spec MatisseGauguin using RVS spectra and Monte Carlo realisations, applied to the individual N lines of the element, given in {\tt tifeGspspecNlines} [''dex'']';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.tife_gspspec_lower IS '16th percentile of the abundance of Titanium [Ti/Fe] from GSP-Spec MatisseGauguin using RVS spectra and Monte Carlo realisations [''dex'']';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.tife_gspspec_upper IS '84th percentile of the abundance of Titanium [Ti/Fe] from GSP-Spec MatisseGauguin using RVS spectra and Monte Carlo realisations [''dex'']';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.tife_gspspec_nlines IS 'Number of lines used for [Ti/Fe] abundance estimation';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.tife_gspspec_linescatter IS 'Uncertainty estimation of [Ti/Fe] abundance using N lines of the element, given in {\tt tifeGspspecNlines} [''dex'']';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.mgfe_gspspec IS 'Abundance of Magnesium [Mg/Fe] from GSP-Spec MatisseGauguin using RVS spectra and Monte Carlo realisations, applied to the individual N lines of the element, given in {\tt mgfeGspspecNlines} [''dex'']';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.mgfe_gspspec_lower IS '16th percentile of the abundance of Magnesium [Mg/Fe] from GSP-Spec MatisseGauguin using RVS spectra and Monte Carlo realisations [''dex'']';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.mgfe_gspspec_upper IS '84th percentile of the abundance of Magnesium [Mg/Fe] from GSP-Spec MatisseGauguin using RVS spectra and Monte Carlo realisations [''dex'']';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.mgfe_gspspec_nlines IS 'Number of lines used for [Mg/Fe] abundance estimation';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.mgfe_gspspec_linescatter IS 'Uncertainty estimation of [Mg/Fe] abundance using N lines of the element, given in {\tt mgfeGspspecNlines} [''dex'']';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.ndfe_gspspec IS 'Abundance of neodymium [Nd/Fe] from GSP-Spec MatisseGauguin using RVS spectra and Monte Carlo realisations, applied to the individual N lines of the element, given in {\tt ndfeGspspecNlines} [''dex'']';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.ndfe_gspspec_lower IS '16th percentile of the abundance of neodymium [Nd/Fe] from GSP-Spec MatisseGauguin using RVS spectra and Monte Carlo realisations [''dex'']';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.ndfe_gspspec_upper IS '84th percentile of the abundance of neodymium [Nd/Fe] from GSP-Spec MatisseGauguin using RVS spectra and Monte Carlo realisations [''dex'']';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.ndfe_gspspec_nlines IS 'Number of lines used for [Nd/Fe] abundance estimation';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.ndfe_gspspec_linescatter IS 'Uncertainty estimation of [Nd/Fe] abundance using N lines of the element, given in {\tt ndfeGspspecNlines} [''dex'']';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.feiim_gspspec IS 'Abundance of ionised iron [FeII/M] from GSP-Spec MatisseGauguin using RVS spectra and Monte Carlo realisations, applied to the individual N lines of the element, given in {\tt feiimGspspecNlines} [''dex'']';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.feiim_gspspec_lower IS '16th percentile of the abundance of ionised iron [FeII/M] from GSP-Spec MatisseGauguin using RVS spectra and Monte Carlo realisations [''dex'']';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.feiim_gspspec_upper IS '84th percentile of the abundance of ionised iron [FeII/M] from GSP-Spec MatisseGauguin using RVS spectra and Monte Carlo realisations [''dex'']';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.feiim_gspspec_nlines IS 'Number of lines used for [FeII/M] abundance estimation';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.feiim_gspspec_linescatter IS 'Uncertainty estimation of [FeII/M] abundance using N lines of the element, given in {\tt feiimGspspecNlines} [''dex'']';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.sfe_gspspec IS 'Abundance of Sulphur [S/Fe] from GSP-Spec MatisseGauguin using RVS spectra and Monte Carlo realisations, applied to the individual N lines of the element, given in {\tt sfeGspspecNlines} [''dex'']';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.sfe_gspspec_lower IS '16th percentile of the abundance of Sulphur [S/Fe] from GSP-Spec MatisseGauguin using RVS spectra and Monte Carlo realisations [''dex'']';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.sfe_gspspec_upper IS '84th percentile of the abundance of Sulphur [S/Fe] from GSP-Spec MatisseGauguin using RVS spectra and Monte Carlo realisations [''dex'']';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.sfe_gspspec_nlines IS 'Number of lines used for [S/Fe] abundance estimation';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.sfe_gspspec_linescatter IS 'Uncertainty estimation of [S/Fe] abundance using N lines of the element, given in {\tt sfeGspspecNlines} [''dex'']';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.zrfe_gspspec IS 'Abundance of Zirconium [Zr/Fe] from GSP-Spec MatisseGauguin using RVS spectra and Monte Carlo realisations, applied to the individual N lines of the element, given in {\tt zrfeGspspecNlines} [''dex'']';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.zrfe_gspspec_lower IS '16th percentile of the abundance of Zirconium [Zr/Fe] from GSP-Spec MatisseGauguin using RVS spectra and Monte Carlo realisations [''dex'']';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.zrfe_gspspec_upper IS '84th percentile of the abundance of Zirconium [Zr/Fe] from GSP-Spec MatisseGauguin using RVS spectra and Monte Carlo realisations [''dex'']';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.zrfe_gspspec_nlines IS 'Number of lines used for [Zr/Fe] abundance estimation';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.zrfe_gspspec_linescatter IS 'Uncertainty estimation of [Zr/Fe] abundance using N lines of the element, given in {\tt zrfeGspspecNlines} [''dex'']';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.nfe_gspspec IS 'Abundance of Nitrogen [N/Fe] from GSP-Spec MatisseGauguin using RVS spectra and Monte Carlo realisations, applied to the individual N lines of the element, given in {\tt nfeGspspecNlines} [''dex'']';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.nfe_gspspec_lower IS '16th percentile of the abundance of Nitrogen [N/Fe] from GSP-Spec MatisseGauguin using RVS spectra and Monte Carlo realisations [''dex'']';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.nfe_gspspec_upper IS '84th percentile of the abundance of Nitrogen [N/Fe] from GSP-Spec MatisseGauguin using RVS spectra and Monte Carlo realisations [''dex'']';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.nfe_gspspec_nlines IS 'Number of lines used for [N/Fe] abundance estimation';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.nfe_gspspec_linescatter IS 'Uncertainty estimation of [N/Fe] abundance using N lines of the element, given in {\tt nfeGspspecNlines} [''dex'']';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.crfe_gspspec IS 'Abundance of Chromium [Cr/Fe] from GSP-Spec MatisseGauguin using RVS spectra and Monte Carlo realisations, applied to the individual N lines of the element, given in {\tt crfeGspspecNlines} [''dex'']';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.crfe_gspspec_lower IS '16th percentile of the abundance of Chromium [Cr/Fe] from GSP-Spec MatisseGauguin using RVS spectra and Monte Carlo realisations [''dex'']';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.crfe_gspspec_upper IS '84th percentile of the abundance of Chromium [Cr/Fe] from GSP-Spec MatisseGauguin using RVS spectra and Monte Carlo realisations [''dex'']';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.crfe_gspspec_nlines IS 'Number of lines used for [Cr/Fe] abundance estimation';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.crfe_gspspec_linescatter IS 'Uncertainty estimation of [Cr/Fe] abundance using N lines of the element, given in {\tt crfeGspspecNlines} [''dex'']';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.cefe_gspspec IS 'Abundance of Cerium [Ce/Fe] from GSP-Spec MatisseGauguin using RVS spectra and Monte Carlo realisations, applied to the individual N lines of the element, given in {\tt cefeGspspecNlines} [''dex'']';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.cefe_gspspec_lower IS '16th percentile of the abundance of Cerium [Ce/Fe] from GSP-Spec MatisseGauguin using RVS spectra and Monte Carlo realisations [''dex'']';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.cefe_gspspec_upper IS '84th percentile of the abundance of Cerium [Ce/Fe] from GSP-Spec MatisseGauguin using RVS spectra and Monte Carlo realisations [''dex'']';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.cefe_gspspec_nlines IS 'Number of lines used for [Ce/Fe] abundance estimation';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.cefe_gspspec_linescatter IS 'Uncertainty estimation of [Ce/Fe] abundance using N lines of the element, given in {\tt cefeGspspecNlines} [''dex'']';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.nife_gspspec IS 'Abundance of Nickel [Ni/Fe] from GSP-Spec MatisseGauguin using RVS spectra and Monte Carlo realisations, applied to the individual N lines of the element, given in {\tt nifeGspspecNlines} [''dex'']';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.nife_gspspec_lower IS '16th percentile of the abundance of Nickel [Ni/Fe] from GSP-Spec MatisseGauguin using RVS spectra and Monte Carlo realisations [''dex'']';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.nife_gspspec_upper IS '84th percentile of the abundance of Nickel [Ni/Fe] from GSP-Spec MatisseGauguin using RVS spectra and Monte Carlo realisations [''dex'']';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.nife_gspspec_nlines IS 'Number of lines used for [Ni/Fe] abundance estimation';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.nife_gspspec_linescatter IS 'Uncertainty estimation of [Ni/Fe] abundance using N lines of the element, given in {\tt nifeGspspecNlines} [''dex'']';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.cn0ew_gspspec IS 'Equivalent witdh of cyanogen absorption line, derived from RVS spectra [nm]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.cn0ew_gspspec_uncertainty IS 'Uncertainty of equivalent witdh of cyanogen absorption line, derived from RVS spectra [nm]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.cn0_gspspec_centralline IS 'Central wavelength of cyanogen line, derived from RVS spectra using DIB algorithm [nm]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.cn0_gspspec_width IS 'Width of cyoanogen line, derived from RVS spectra using DIB algorithm [nm]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.dib_gspspec_lambda IS 'DIB central wavelength from GSP-Spec MatisseGauguin using RVS spectra [nm]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.dib_gspspec_lambda_uncertainty IS 'Uncertainty on DIB central wavelength from GSP-Spec MatisseGauguin using RVS spectra [nm]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.dibew_gspspec IS 'Equivalent width of the DIB from GSP-Spec MatisseGauguin using RVS spectra [angstrom]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.dibew_gspspec_uncertainty IS 'Global uncertainty on DIB equivalent width value using DIB algorithm [angstrom]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.dibewnoise_gspspec_uncertainty IS 'Uncertainty on DIB equivalent width value occuring from noise part [angstrom]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.dibp0_gspspec IS 'Depth ($p_0$ parameter) of the DIB derived from a Gaussian model fit';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.dibp2_gspspec IS 'Width ($p_2$ parameter) of the DIB derived from a Gaussian model fit [angstrom]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.dibp2_gspspec_uncertainty IS 'Uncertainty on the {\tt dibp2Gspspec} parameter [angstrom]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.dibqf_gspspec IS 'Quality flag of the DIB computation';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.flags_gspspec IS 'Catalogue flags for GSP-Spec MatisseGauguin';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.logchisq_gspspec IS 'Logarithm of the goodness-of-fit for the GSP-Spec MatisseGauguin parameters';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.ew_espels_halpha IS 'Halpha pseudo-equivalent width from ESP-ELS [nm]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.ew_espels_halpha_uncertainty IS 'Uncertainty of the Halpha pseudo-equivalent width from ESP-ELS [nm]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.ew_espels_halpha_flag IS 'Quality flag of the Halpha pseudo-equivalent width from ESP-ELS';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.ew_espels_halpha_model IS 'Halpha pseudo-equivalent width from ESP-ELS measured on the synthetic spectrum [nm]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.classlabel_espels IS 'Adopted ELS class label from ESP-ELS';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.classlabel_espels_flag IS 'Quality flag of the adopted ELS class label from ESP-ELS';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.classprob_espels_wcstar IS 'Probability from ESP-ELS of being a Wolf-Rayet star of type WC';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.classprob_espels_wnstar IS 'Probability from ESP-ELS of being a Wolf-Rayet star of type WN';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.classprob_espels_bestar IS 'Probability from ESP-ELS of being a Be Star';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.classprob_espels_ttauristar IS 'Probability from ESP-ELS of being a T Tauri Star';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.classprob_espels_herbigstar IS 'Probability from ESP-ELS of being a Herbig Ae/Be Star';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.classprob_espels_dmestar IS 'Probability from ESP-ELS of being an active M dwarf Star';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.classprob_espels_pne IS 'Probability from ESP-ELS of being a planetary nebula';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.azero_esphs IS 'Monochromatic interstellar extinction, A$_\mathrm{0}$, from ESP-HS [mag]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.azero_esphs_uncertainty IS 'Uncertainty at a 68% confidence level on A$_\mathrm{0}$ from ESP-HS [mag]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.ag_esphs IS 'Intersterstellar extinction in G band from ESP-HS [mag]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.ag_esphs_uncertainty IS 'Uncertainty on $A_{\rm G}$ from ESP-HS [mag]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.ebpminrp_esphs IS 'Reddening $E(G_{\rm BP} - G_{\rm RP})$ from ESP-HS [mag]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.ebpminrp_esphs_uncertainty IS 'Uncertainty on $E(G_{\rm BP} - G_{\rm RP})$ from ESP-HS [mag]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.teff_esphs IS 'Effective temperature from ESP-HS [K]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.teff_esphs_uncertainty IS 'Uncertainty at a 68% confidence level on the effective temperature from ESP-HS [K]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.logg_esphs IS 'Surface gravity from ESP-HS [log(cm.s**-2)]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.logg_esphs_uncertainty IS 'Uncertainty at a 68% confidence level on the surface gravity from ESP-HS [log(cm.s**-2)]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.vsini_esphs IS 'Projected rotational velocity from ESP-HS [km.s**-1]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.vsini_esphs_uncertainty IS 'Uncertainty on the projected rotational velocity from ESP-HS [km.s**-1]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.flags_esphs IS 'Quality flag of the ESP-HS parametrisation';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.spectraltype_esphs IS 'Spectral type from ESP-ELS';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.activityindex_espcs IS 'Chromospheric activity index from ESP-CS, measured on the calcium triplet using RVS spectra [nm]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.activityindex_espcs_uncertainty IS 'Uncertainty in the chromospheric activity index from ESP-CS [nm]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.activityindex_espcs_input IS 'Source of input stellar parameters for the computation of the activity index by ESP-CS';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.teff_espucd IS 'Effective temperature estimate from ESP-UCD based on the RP spectrum [K]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.teff_espucd_uncertainty IS 'Uncertainty of the effective temperature estimate produced by ESP-UCD [K]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.flags_espucd IS 'Quality flags of the ESP-UCD parameter estimates';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.radius_flame IS 'Radius of the star from FLAME using {\tt teffGspphot} and {\tt lumFlame} [solRad]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.radius_flame_lower IS 'Lower confidence level (16%) of {\tt radiusFlame} [solRad]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.radius_flame_upper IS 'Upper confidence level (84%) of {\tt radiusFlame} [solRad]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.lum_flame IS 'Luminosity of the star from FLAME using G band magnitude, extinction ({\tt agGspphot}), parallax or distance, and a bolometric correction {\tt bcFlame} [solLum]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.lum_flame_lower IS 'Lower confidence level (16%) of {\tt lumFlame} [solLum]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.lum_flame_upper IS 'Upper confidence level (84%) of {\tt lumFlame} [solLum]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.mass_flame IS 'Mass of the star from FLAME using stellar models, {\tt lumFlame}, and {\tt teffGspphot} [solMass]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.mass_flame_lower IS 'Lower confidence level (16%) of {\tt massFlame} [solMass]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.mass_flame_upper IS 'Upper confidence level (84%) of {\tt massFlame} [solMass]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.age_flame IS 'Age of the star from FLAME using stellar models, see {\tt massFlame} for details [Gyr]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.age_flame_lower IS 'Lower confidence level (16%) of {\tt ageFlame} [Gyr]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.age_flame_upper IS 'Upper confidence level (84%) of {\tt ageFlame} [Gyr]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.flags_flame IS 'Flags indicating quality and processing information from FLAME';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.evolstage_flame IS 'Evolutionary stage of the star from FLAME using stellar models, see {\tt massFlame} for details';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.gravredshift_flame IS 'Gravitational redshift from FLAME using {\tt radiusFlame} and {\tt loggGspphot} [km.s**-1]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.gravredshift_flame_lower IS 'Lower confidence level (16%) of {\tt gravredshiftFlame} [km.s**-1]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.gravredshift_flame_upper IS 'Upper confidence level (84%) of {\tt gravredshiftFlame} [km.s**-1]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.bc_flame IS 'Bolometric correction used to derive {\tt lumFlame} [mag]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.mh_msc IS 'Metallicity of the source treated as a binary system from MSC using BP/RP spectra and parallax [''dex'']';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.mh_msc_upper IS 'Upper confidence level (84%) of the metallicity from MSC using BP/RP spectra and parallax [''dex'']';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.mh_msc_lower IS 'Lower confidence level (16%) of the metallicity from MSC using BP/RP spectra and parallax [''dex'']';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.azero_msc IS 'Monochromatic extinction $A_0$ at 547.7nm of the source treated as a binary system from MSC using BP/RP spectra and parallax [mag]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.azero_msc_upper IS 'Upper confidence level (84%) of monochromatic extinction $A_0$ at 547.7nm from MSC using BP/RP spectra and parallax [mag]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.azero_msc_lower IS 'Lower confidence level (16%) of monochromatic extinction $A_0$ at 547.7nm from MSC using BP/RP spectra and parallax [mag]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.distance_msc IS 'Distance from MSC using BP/RP spectra and parallax [pc]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.distance_msc_upper IS 'Upper confidence level (84%) of distance from MSC using BP/RP spectra and parallax [pc]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.distance_msc_lower IS 'Lower confidence level (16%) of distance from MSC using BP/RP spectra and parallax [pc]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.teff_msc1 IS 'Effective temperature of the primary from MSC using BP/RP spectra and parallax [K]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.teff_msc1_upper IS 'Upper confidence level (84%) of effective temperature of the primary from MSC using BP/RP spectra and parallax [K]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.teff_msc1_lower IS 'Lower confidence level (16%) of effective temperature of the primary from MSC using BP/RP spectra and parallax [K]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.teff_msc2 IS 'Effective temperature of the secondary from MSC using BP/RP spectra and parallax [K]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.teff_msc2_upper IS 'Upper confidence level (84%) of effective temperature of the secondary from MSC using BP/RP spectra and parallax [K]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.teff_msc2_lower IS 'Lower confidence level (16%) of effective temperature of the secondary from MSC using BP/RP spectra and parallax [K]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.logg_msc1 IS 'Surface gravity of the primary from MSC using BP/RP spectra and parallax [log(cm.s**-2)]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.logg_msc1_upper IS 'Upper confidence level (84%) of surface gravity of the primary from MSC using BP/RP spectra and parallax [log(cm.s**-2)]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.logg_msc1_lower IS 'Lower confidence level (16%) of surface gravity of the primary from MSC using BP/RP spectra and parallax [log(cm.s**-2)]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.logg_msc2 IS 'Surface gravity of the secondary from MSC using BP/RP spectra and parallax [log(cm.s**-2)]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.logg_msc2_upper IS 'Upper confidence level (84%) of surface gravity of the secondary from MSC using BP/RP spectra and parallax [log(cm.s**-2)]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.logg_msc2_lower IS 'Lower confidence level (16%) of surface gravity of the secondary from MSC using BP/RP spectra and parallax [log(cm.s**-2)]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.ag_msc IS 'Extinction in G band of the source treated as a binary system from MSC using BP/RP spectra and parallax [mag]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.ag_msc_upper IS 'Upper confidence level (84%) of extinction in G band from MSC using BP/RP spectra and parallax [mag]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.ag_msc_lower IS 'Lower confidence level (16%) of extinction in G band from MSC using BP/RP spectra and parallax [mag]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.logposterior_msc IS 'Goodness-of-fit score (normalised log-posterior) of MSC MCMC';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.mcmcaccept_msc IS 'Mean MCMC acceptance rate of MSC MCMC';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.mcmcdrift_msc IS 'Mean drift of the MSC MCMC chain in units of parameter standard deviation';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.flags_msc IS 'Flag indicating quality information from MSC';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.neuron_oa_id IS 'Identifier of the OA SOM map neuron that represents the source';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.neuron_oa_dist IS 'Distance between the source XP spectra and the OA neuron XP prototype that represents the source';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.neuron_oa_dist_percentile_rank IS 'Percentile rank according to the distance distribution of the OA neuron that represents the source';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters.flags_oa IS 'Flags indicating quality and processing information from OA';
CREATE INDEX IF NOT EXISTS gaiadr3_astrophysical_parameters_source_id_idx ON gaiadr3.astrophysical_parameters (source_id);

-- [Parámetros astrofísicos] gaiadr3.astrophysical_parameters_supp — acceso: TAP Gaia (ADQL)
CREATE TABLE IF NOT EXISTS gaiadr3.astrophysical_parameters_supp (
    solution_id bigint,
    source_id bigint,
    libname_best_gspphot text,
    teff_gspphot_marcs real,
    teff_gspphot_marcs_lower real,
    teff_gspphot_marcs_upper real,
    logg_gspphot_marcs real,
    logg_gspphot_marcs_lower real,
    logg_gspphot_marcs_upper real,
    mh_gspphot_marcs real,
    mh_gspphot_marcs_lower real,
    mh_gspphot_marcs_upper real,
    distance_gspphot_marcs real,
    distance_gspphot_marcs_lower real,
    distance_gspphot_marcs_upper real,
    azero_gspphot_marcs real,
    azero_gspphot_marcs_lower real,
    azero_gspphot_marcs_upper real,
    ag_gspphot_marcs real,
    ag_gspphot_marcs_lower real,
    ag_gspphot_marcs_upper real,
    abp_gspphot_marcs real,
    abp_gspphot_marcs_lower real,
    abp_gspphot_marcs_upper real,
    arp_gspphot_marcs real,
    arp_gspphot_marcs_lower real,
    arp_gspphot_marcs_upper real,
    ebpminrp_gspphot_marcs real,
    ebpminrp_gspphot_marcs_lower real,
    ebpminrp_gspphot_marcs_upper real,
    mg_gspphot_marcs real,
    mg_gspphot_marcs_lower real,
    mg_gspphot_marcs_upper real,
    radius_gspphot_marcs real,
    radius_gspphot_marcs_lower real,
    radius_gspphot_marcs_upper real,
    logposterior_gspphot_marcs real,
    mcmcaccept_gspphot_marcs real,
    teff_gspphot_phoenix real,
    teff_gspphot_phoenix_lower real,
    teff_gspphot_phoenix_upper real,
    logg_gspphot_phoenix real,
    logg_gspphot_phoenix_lower real,
    logg_gspphot_phoenix_upper real,
    mh_gspphot_phoenix real,
    mh_gspphot_phoenix_lower real,
    mh_gspphot_phoenix_upper real,
    distance_gspphot_phoenix real,
    distance_gspphot_phoenix_lower real,
    distance_gspphot_phoenix_upper real,
    azero_gspphot_phoenix real,
    azero_gspphot_phoenix_lower real,
    azero_gspphot_phoenix_upper real,
    ag_gspphot_phoenix real,
    ag_gspphot_phoenix_lower real,
    ag_gspphot_phoenix_upper real,
    abp_gspphot_phoenix real,
    abp_gspphot_phoenix_lower real,
    abp_gspphot_phoenix_upper real,
    arp_gspphot_phoenix real,
    arp_gspphot_phoenix_lower real,
    arp_gspphot_phoenix_upper real,
    ebpminrp_gspphot_phoenix real,
    ebpminrp_gspphot_phoenix_lower real,
    ebpminrp_gspphot_phoenix_upper real,
    mg_gspphot_phoenix real,
    mg_gspphot_phoenix_lower real,
    mg_gspphot_phoenix_upper real,
    radius_gspphot_phoenix real,
    radius_gspphot_phoenix_lower real,
    radius_gspphot_phoenix_upper real,
    logposterior_gspphot_phoenix real,
    mcmcaccept_gspphot_phoenix real,
    teff_gspphot_ob real,
    teff_gspphot_ob_lower real,
    teff_gspphot_ob_upper real,
    logg_gspphot_ob real,
    logg_gspphot_ob_lower real,
    logg_gspphot_ob_upper real,
    mh_gspphot_ob real,
    mh_gspphot_ob_lower real,
    mh_gspphot_ob_upper real,
    distance_gspphot_ob real,
    distance_gspphot_ob_lower real,
    distance_gspphot_ob_upper real,
    azero_gspphot_ob real,
    azero_gspphot_ob_lower real,
    azero_gspphot_ob_upper real,
    ag_gspphot_ob real,
    ag_gspphot_ob_lower real,
    ag_gspphot_ob_upper real,
    abp_gspphot_ob real,
    abp_gspphot_ob_lower real,
    abp_gspphot_ob_upper real,
    arp_gspphot_ob real,
    arp_gspphot_ob_lower real,
    arp_gspphot_ob_upper real,
    ebpminrp_gspphot_ob real,
    ebpminrp_gspphot_ob_lower real,
    ebpminrp_gspphot_ob_upper real,
    mg_gspphot_ob real,
    mg_gspphot_ob_lower real,
    mg_gspphot_ob_upper real,
    radius_gspphot_ob real,
    radius_gspphot_ob_lower real,
    radius_gspphot_ob_upper real,
    logposterior_gspphot_ob real,
    mcmcaccept_gspphot_ob real,
    teff_gspphot_a real,
    teff_gspphot_a_lower real,
    teff_gspphot_a_upper real,
    logg_gspphot_a real,
    logg_gspphot_a_lower real,
    logg_gspphot_a_upper real,
    mh_gspphot_a real,
    mh_gspphot_a_lower real,
    mh_gspphot_a_upper real,
    distance_gspphot_a real,
    distance_gspphot_a_lower real,
    distance_gspphot_a_upper real,
    azero_gspphot_a real,
    azero_gspphot_a_lower real,
    azero_gspphot_a_upper real,
    ag_gspphot_a real,
    ag_gspphot_a_lower real,
    ag_gspphot_a_upper real,
    abp_gspphot_a real,
    abp_gspphot_a_lower real,
    abp_gspphot_a_upper real,
    arp_gspphot_a real,
    arp_gspphot_a_lower real,
    arp_gspphot_a_upper real,
    ebpminrp_gspphot_a real,
    ebpminrp_gspphot_a_lower real,
    ebpminrp_gspphot_a_upper real,
    mg_gspphot_a real,
    mg_gspphot_a_lower real,
    mg_gspphot_a_upper real,
    radius_gspphot_a real,
    radius_gspphot_a_lower real,
    radius_gspphot_a_upper real,
    logposterior_gspphot_a real,
    mcmcaccept_gspphot_a real,
    teff_gspspec_ann real,
    teff_gspspec_ann_lower real,
    teff_gspspec_ann_upper real,
    logg_gspspec_ann real,
    logg_gspspec_ann_lower real,
    logg_gspspec_ann_upper real,
    mh_gspspec_ann real,
    mh_gspspec_ann_lower real,
    mh_gspspec_ann_upper real,
    alphafe_gspspec_ann real,
    alphafe_gspspec_ann_lower real,
    alphafe_gspspec_ann_upper real,
    logchisq_gspspec_ann real,
    flags_gspspec_ann text,
    radius_flame_spec real,
    radius_flame_spec_lower real,
    radius_flame_spec_upper real,
    lum_flame_spec real,
    lum_flame_spec_lower real,
    lum_flame_spec_upper real,
    mass_flame_spec real,
    mass_flame_spec_lower real,
    mass_flame_spec_upper real,
    age_flame_spec real,
    age_flame_spec_lower real,
    age_flame_spec_upper real,
    flags_flame_spec text,
    evolstage_flame_spec integer,
    gravredshift_flame_spec real,
    gravredshift_flame_spec_lower real,
    gravredshift_flame_spec_upper real,
    bc_flame_spec real
);
COMMENT ON TABLE gaiadr3.astrophysical_parameters_supp IS 'This table contains additional parameters from the Apsis processing chain, compared to the main table {\tt AstrophysicalParameters} (see Chapter~\ref{chap:cu8par}), from modules that produce more than one result for a parameter. It contains (1) the individual library results from GSP-Phot (see Section~\ref{ssec:cu8par_apsis_gspphot_method}), (2) FLAME results from processing GSP-Spec parameters given in the {\tt AstrophysicalParameters} table (see Section~\ref{ssec:cu8par_apsis_flame}), and (3) results from the GSP-Spec ANN algorithm (see Section~\ref{ssec:cu8par_apsis_gspspec}).';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters_supp.solution_id IS 'Solution Identifier';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters_supp.source_id IS 'Source Identifier';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters_supp.libname_best_gspphot IS 'Name of library that achieves the highest mean log-posterior in MCMC samples from GSP-Phot Aeneas';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters_supp.teff_gspphot_marcs IS 'Effective temperature from GSP-Phot Aeneas for MARCS library using BP/RP spectra [K]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters_supp.teff_gspphot_marcs_lower IS 'Lower confidence level (16%) of effective temperature from GSP-Phot Aeneas for MARCS library using BP/RP spectra [K]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters_supp.teff_gspphot_marcs_upper IS 'Upper confidence level (84%) of effective temperature from GSP-Phot Aeneas for MARCS library using BP/RP spectra [K]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters_supp.logg_gspphot_marcs IS 'Surface gravity from GSP-Phot Aeneas for MARCS library using BP/RP spectra [log(cm.s**-2)]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters_supp.logg_gspphot_marcs_lower IS 'Lower confidence level (16%) of surface gravity from GSP-Phot Aeneas for MARCS library using BP/RP spectra [log(cm.s**-2)]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters_supp.logg_gspphot_marcs_upper IS 'Upper confidence level (84%) of surface gravity from GSP-Phot Aeneas for MARCS library using BP/RP spectra [log(cm.s**-2)]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters_supp.mh_gspphot_marcs IS 'Iron abundance from GSP-Phot Aeneas for MARCS library using BP/RP spectra [''dex'']';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters_supp.mh_gspphot_marcs_lower IS 'Lower confidence level (16%) of iron abundance from GSP-Phot Aeneas for MARCS library using BP/RP spectra [''dex'']';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters_supp.mh_gspphot_marcs_upper IS 'Upper confidence level (84%) of iron abundance from GSP-Phot Aeneas for MARCS library using BP/RP spectra [''dex'']';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters_supp.distance_gspphot_marcs IS 'Distance from GSP-Phot Aeneas for MARCS library using BP/RP spectra [pc]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters_supp.distance_gspphot_marcs_lower IS 'Lower confidence level (16%) of distance from GSP-Phot Aeneas for MARCS library using BP/RP spectra [pc]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters_supp.distance_gspphot_marcs_upper IS 'Upper confidence level (84%) of distance from GSP-Phot Aeneas for MARCS library using BP/RP spectra [pc]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters_supp.azero_gspphot_marcs IS 'Monochromatic extinction $A_0$ at 547.7nm from GSP-Phot Aeneas for MARCS library using BP/RP spectra [mag]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters_supp.azero_gspphot_marcs_lower IS 'Lower confidence level (16%) of monochromatic extinction $A_0$ at 547.7nm from GSP-Phot Aeneas for MARCS library using BP/RP spectra [mag]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters_supp.azero_gspphot_marcs_upper IS 'Upper confidence level (84%) of monochromatic extinction $A_0$ at 547.7nm from GSP-Phot Aeneas for MARCS library using BP/RP spectra [mag]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters_supp.ag_gspphot_marcs IS 'Extinction in G band from GSP-Phot Aeneas for MARCS library using BP/RP spectra [mag]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters_supp.ag_gspphot_marcs_lower IS 'Lower confidence level (16%) of extinction in G band from GSP-Phot Aeneas for MARCS library using BP/RP spectra [mag]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters_supp.ag_gspphot_marcs_upper IS 'Upper confidence level (84%) of extinction in G band from GSP-Phot Aeneas for MARCS library using BP/RP spectra [mag]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters_supp.abp_gspphot_marcs IS 'Extinction in $G_{BP}$ band from GSP-Phot Aeneas for MARCS library using BP/RP spectra [mag]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters_supp.abp_gspphot_marcs_lower IS 'Lower confidence level (16%) of extinction in $G_{BP}$ band from GSP-Phot Aeneas for MARCS library using BP/RP spectra [mag]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters_supp.abp_gspphot_marcs_upper IS 'Upper confidence level (84%) of extinction in $G_{BP}$ band from GSP-Phot Aeneas for MARCS library using BP/RP spectra [mag]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters_supp.arp_gspphot_marcs IS 'Extinction in $G_{RP}$ band from GSP-Phot Aeneas for MARCS library using BP/RP spectra [mag]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters_supp.arp_gspphot_marcs_lower IS 'Lower confidence level (16%) of extinction in $G_{RP}$ band from GSP-Phot Aeneas for MARCS library using BP/RP spectra [mag]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters_supp.arp_gspphot_marcs_upper IS 'Upper confidence level (84%) of extinction in $G_{RP}$ band from GSP-Phot Aeneas for MARCS library using BP/RP spectra [mag]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters_supp.ebpminrp_gspphot_marcs IS 'Reddening $E(BP-RP)$ from GSP-Phot Aeneas for MARCS library using BP/RP spectra [mag]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters_supp.ebpminrp_gspphot_marcs_lower IS 'Lower confidence level (16%) of reddening $E(BP-RP)$ from GSP-Phot Aeneas for MARCS library using BP/RP spectra [mag]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters_supp.ebpminrp_gspphot_marcs_upper IS 'Upper confidence level (84%) of reddening $E(BP-RP)$ from GSP-Phot Aeneas for MARCS library using BP/RP spectra [mag]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters_supp.mg_gspphot_marcs IS 'Absolute magnitude $M_G$ from GSP-Phot Aeneas for MARCS library using BP/RP spectra [mag]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters_supp.mg_gspphot_marcs_lower IS 'Lower confidence level (16%) of absolute magnitude $M_G$ from GSP-Phot Aeneas for MARCS library using BP/RP spectra [mag]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters_supp.mg_gspphot_marcs_upper IS 'Upper confidence level (84%) of absolute magnitude $M_G$ from GSP-Phot Aeneas for MARCS library using BP/RP spectra [mag]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters_supp.radius_gspphot_marcs IS 'Radius from GSP-Phot Aeneas for MARCS library using BP/RP spectra [solRad]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters_supp.radius_gspphot_marcs_lower IS 'Lower confidence level (16%) of radius from GSP-Phot Aeneas for MARCS library using BP/RP spectra [solRad]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters_supp.radius_gspphot_marcs_upper IS 'Upper confidence level (84%) of radius from GSP-Phot Aeneas for MARCS library using BP/RP spectra [solRad]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters_supp.logposterior_gspphot_marcs IS 'Goodness-of-fit score (mean log-posterior of MCMC) of GSP-Phot Aeneas MCMC for MARCS library';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters_supp.mcmcaccept_gspphot_marcs IS 'MCMC acceptance rate of GSP-Phot Aeneas MCMC for MARCS library';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters_supp.teff_gspphot_phoenix IS 'Effective temperature from GSP-Phot Aeneas for PHOENIX library using BP/RP spectra [K]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters_supp.teff_gspphot_phoenix_lower IS 'Lower confidence level (16%) of effective temperature from GSP-Phot Aeneas for PHOENIX library using BP/RP spectra [K]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters_supp.teff_gspphot_phoenix_upper IS 'Upper confidence level (84%) of effective temperature from GSP-Phot Aeneas for PHOENIX library using BP/RP spectra [K]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters_supp.logg_gspphot_phoenix IS 'Surface gravity from GSP-Phot Aeneas for PHOENIX library using BP/RP spectra [log(cm.s**-2)]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters_supp.logg_gspphot_phoenix_lower IS 'Lower confidence level (16%) of surface gravity from GSP-Phot Aeneas for PHOENIX library using BP/RP spectra [log(cm.s**-2)]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters_supp.logg_gspphot_phoenix_upper IS 'Upper confidence level (84%) of surface gravity from GSP-Phot Aeneas for PHOENIX library using BP/RP spectra [log(cm.s**-2)]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters_supp.mh_gspphot_phoenix IS 'Iron abundance from GSP-Phot Aeneas for PHOENIX library using BP/RP spectra [''dex'']';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters_supp.mh_gspphot_phoenix_lower IS 'Lower confidence level (16%) of iron abundance from GSP-Phot Aeneas for PHOENIX library using BP/RP spectra [''dex'']';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters_supp.mh_gspphot_phoenix_upper IS 'Upper confidence level (84%) of iron abundance from GSP-Phot Aeneas for PHOENIX library using BP/RP spectra [''dex'']';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters_supp.distance_gspphot_phoenix IS 'Distance from GSP-Phot Aeneas for PHOENIX library using BP/RP spectra [pc]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters_supp.distance_gspphot_phoenix_lower IS 'Lower confidence level (16%) of distance from GSP-Phot Aeneas for PHOENIX library using BP/RP spectra [pc]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters_supp.distance_gspphot_phoenix_upper IS 'Upper confidence level (84%) of distance from GSP-Phot Aeneas for PHOENIX library using BP/RP spectra [pc]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters_supp.azero_gspphot_phoenix IS 'Monochromatic extinction $A_0$ at 547.7nm from GSP-Phot Aeneas for PHOENIX library using BP/RP spectra [mag]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters_supp.azero_gspphot_phoenix_lower IS 'Lower confidence level (16%) of monochromatic extinction $A_0$ at 547.7nm from GSP-Phot Aeneas for PHOENIX library using BP/RP spectra [mag]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters_supp.azero_gspphot_phoenix_upper IS 'Upper confidence level (84%) of monochromatic extinction $A_0$ at 547.7nm from GSP-Phot Aeneas for PHOENIX library using BP/RP spectra [mag]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters_supp.ag_gspphot_phoenix IS 'Extinction in G band from GSP-Phot Aeneas for PHOENIX library using BP/RP spectra [mag]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters_supp.ag_gspphot_phoenix_lower IS 'Lower confidence level (16%) of extinction in G band from GSP-Phot Aeneas for PHOENIX library using BP/RP spectra [mag]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters_supp.ag_gspphot_phoenix_upper IS 'Upper confidence level (84%) of extinction in G band from GSP-Phot Aeneas for PHOENIX library using BP/RP spectra [mag]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters_supp.abp_gspphot_phoenix IS 'Extinction in $G_{BP}$ band from GSP-Phot Aeneas for PHOENIX library using BP/RP spectra [mag]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters_supp.abp_gspphot_phoenix_lower IS 'Lower confidence level (16%) of extinction in $G_{BP}$ band from GSP-Phot Aeneas for PHOENIX library using BP/RP spectra [mag]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters_supp.abp_gspphot_phoenix_upper IS 'Upper confidence level (84%) of extinction in $G_{BP}$ band from GSP-Phot Aeneas for PHOENIX library using BP/RP spectra [mag]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters_supp.arp_gspphot_phoenix IS 'Extinction in $G_{RP}$ band from GSP-Phot Aeneas for PHOENIX library using BP/RP spectra [mag]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters_supp.arp_gspphot_phoenix_lower IS 'Lower confidence level (16%) of extinction in $G_{RP}$ band from GSP-Phot Aeneas for PHOENIX library using BP/RP spectra [mag]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters_supp.arp_gspphot_phoenix_upper IS 'Upper confidence level (84%) of extinction in $G_{RP}$ band from GSP-Phot Aeneas for PHOENIX library using BP/RP spectra [mag]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters_supp.ebpminrp_gspphot_phoenix IS 'Reddening $E(BP-RP)$ from GSP-Phot Aeneas for PHOENIX library using BP/RP spectra [mag]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters_supp.ebpminrp_gspphot_phoenix_lower IS 'Lower confidence level (16%) of reddening $E(BP-RP)$ from GSP-Phot Aeneas for PHOENIX library using BP/RP spectra [mag]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters_supp.ebpminrp_gspphot_phoenix_upper IS 'Upper confidence level (84%) of reddening $E(BP-RP)$ from GSP-Phot Aeneas for PHOENIX library using BP/RP spectra [mag]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters_supp.mg_gspphot_phoenix IS 'Absolute magnitude $M_G$ from GSP-Phot Aeneas for PHOENIX library using BP/RP spectra [mag]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters_supp.mg_gspphot_phoenix_lower IS 'Lower confidence level (16%) of absolute magnitude $M_G$ from GSP-Phot Aeneas for PHOENIX library using BP/RP spectra [mag]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters_supp.mg_gspphot_phoenix_upper IS 'Upper confidence level (84%) of absolute magnitude $M_G$ from GSP-Phot Aeneas for PHOENIX library using BP/RP spectra [mag]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters_supp.radius_gspphot_phoenix IS 'Radius from GSP-Phot Aeneas for PHOENIX library using BP/RP spectra [solRad]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters_supp.radius_gspphot_phoenix_lower IS 'Lower confidence level (16%) of radius from GSP-Phot Aeneas for PHOENIX library using BP/RP spectra [solRad]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters_supp.radius_gspphot_phoenix_upper IS 'Upper confidence level (84%) of radius from GSP-Phot Aeneas for PHOENIX library using BP/RP spectra [solRad]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters_supp.logposterior_gspphot_phoenix IS 'Goodness-of-fit score (mean log-posterior of MCMC) of GSP-Phot Aeneas MCMC for PHOENIX library';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters_supp.mcmcaccept_gspphot_phoenix IS 'MCMC acceptance rate of GSP-Phot Aeneas MCMC for PHOENIX library';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters_supp.teff_gspphot_ob IS 'Effective temperature from GSP-Phot Aeneas for OB library using BP/RP spectra [K]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters_supp.teff_gspphot_ob_lower IS 'Lower confidence level (16%) of effective temperature from GSP-Phot Aeneas for OB library using BP/RP spectra [K]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters_supp.teff_gspphot_ob_upper IS 'Upper confidence level (84%) of effective temperature from GSP-Phot Aeneas for OB library using BP/RP spectra [K]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters_supp.logg_gspphot_ob IS 'Surface gravity from GSP-Phot Aeneas for OB library using BP/RP spectra [log(cm.s**-2)]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters_supp.logg_gspphot_ob_lower IS 'Lower confidence level (16%) of surface gravity from GSP-Phot Aeneas for OB library using BP/RP spectra [log(cm.s**-2)]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters_supp.logg_gspphot_ob_upper IS 'Upper confidence level (84%) of surface gravity from GSP-Phot Aeneas for OB library using BP/RP spectra [log(cm.s**-2)]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters_supp.mh_gspphot_ob IS 'Iron abundance from GSP-Phot Aeneas for OB library using BP/RP spectra [''dex'']';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters_supp.mh_gspphot_ob_lower IS 'Lower confidence level (16%) of iron abundance from GSP-Phot Aeneas for OB library using BP/RP spectra [''dex'']';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters_supp.mh_gspphot_ob_upper IS 'Upper confidence level (84%) of iron abundance from GSP-Phot Aeneas for OB library using BP/RP spectra [''dex'']';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters_supp.distance_gspphot_ob IS 'Distance from GSP-Phot Aeneas for OB library using BP/RP spectra [pc]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters_supp.distance_gspphot_ob_lower IS 'Lower confidence level (16%) of distance from GSP-Phot Aeneas for OB library using BP/RP spectra [pc]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters_supp.distance_gspphot_ob_upper IS 'Upper confidence level (84%) of distance from GSP-Phot Aeneas for OB library using BP/RP spectra [pc]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters_supp.azero_gspphot_ob IS 'Monochromatic extinction $A_0$ at 547.7nm from GSP-Phot Aeneas for OB library using BP/RP spectra [mag]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters_supp.azero_gspphot_ob_lower IS 'Lower confidence level (16%) of monochromatic extinction $A_0$ at 547.7nm from GSP-Phot Aeneas for OB library using BP/RP spectra [mag]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters_supp.azero_gspphot_ob_upper IS 'Upper confidence level (84%) of monochromatic extinction $A_0$ at 547.7nm from GSP-Phot Aeneas for OB library using BP/RP spectra [mag]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters_supp.ag_gspphot_ob IS 'Extinction in G band from GSP-Phot Aeneas for OB library using BP/RP spectra [mag]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters_supp.ag_gspphot_ob_lower IS 'Lower confidence level (16%) of extinction in G band from GSP-Phot Aeneas for OB library using BP/RP spectra [mag]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters_supp.ag_gspphot_ob_upper IS 'Upper confidence level (84%) of extinction in G band from GSP-Phot Aeneas for OB library using BP/RP spectra [mag]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters_supp.abp_gspphot_ob IS 'Extinction in $G_{BP}$ band from GSP-Phot Aeneas for OB library using BP/RP spectra [mag]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters_supp.abp_gspphot_ob_lower IS 'Lower confidence level (16%) of extinction in $G_{BP}$ band from GSP-Phot Aeneas for OB library using BP/RP spectra [mag]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters_supp.abp_gspphot_ob_upper IS 'Upper confidence level (84%) of extinction in $G_{BP}$ band from GSP-Phot Aeneas for OB library using BP/RP spectra [mag]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters_supp.arp_gspphot_ob IS 'Extinction in $G_{RP}$ band from GSP-Phot Aeneas for OB library using BP/RP spectra [mag]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters_supp.arp_gspphot_ob_lower IS 'Lower confidence level (16%) of extinction in $G_{RP}$ band from GSP-Phot Aeneas for OB library using BP/RP spectra [mag]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters_supp.arp_gspphot_ob_upper IS 'Upper confidence level (84%) of extinction in $G_{RP}$ band from GSP-Phot Aeneas for OB library using BP/RP spectra [mag]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters_supp.ebpminrp_gspphot_ob IS 'Reddening E(BP-RP) from GSP-Phot Aeneas for OB library using BP/RP spectra [mag]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters_supp.ebpminrp_gspphot_ob_lower IS 'Lower confidence level (16%) of reddening E(BP-RP) from GSP-Phot Aeneas for OB library using BP/RP spectra [mag]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters_supp.ebpminrp_gspphot_ob_upper IS 'Upper confidence level (84%) of reddening E(BP-RP) from GSP-Phot Aeneas for OB library using BP/RP spectra [mag]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters_supp.mg_gspphot_ob IS 'Absolute magnitude $M_G$ from GSP-Phot Aeneas for OB library using BP/RP spectra [mag]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters_supp.mg_gspphot_ob_lower IS 'Lower confidence level (16%) of absolute magnitude $M_G$ from GSP-Phot Aeneas for OB library using BP/RP spectra [mag]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters_supp.mg_gspphot_ob_upper IS 'Upper confidence level (84%) of absolute magnitude $M_G$ from GSP-Phot Aeneas for OB library using BP/RP spectra [mag]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters_supp.radius_gspphot_ob IS 'Radius from GSP-Phot Aeneas for OB library using BP/RP spectra [solRad]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters_supp.radius_gspphot_ob_lower IS 'Lower confidence level (16%) of radius from GSP-Phot Aeneas for OB library using BP/RP spectra [solRad]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters_supp.radius_gspphot_ob_upper IS 'Upper confidence level (84%) of radius from GSP-Phot Aeneas for OB library using BP/RP spectra [solRad]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters_supp.logposterior_gspphot_ob IS 'Goodness-of-fit score (mean log-posterior of MCMC) of GSP-Phot Aeneas MCMC for OB library';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters_supp.mcmcaccept_gspphot_ob IS 'MCMC acceptance rate of GSP-Phot Aeneas MCMC for OB library';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters_supp.teff_gspphot_a IS 'Effective temperature from GSP-Phot Aeneas for A library using BP/RP spectra [K]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters_supp.teff_gspphot_a_lower IS 'Lower confidence level (16%) of effective temperature from GSP-Phot Aeneas for A library using BP/RP spectra [K]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters_supp.teff_gspphot_a_upper IS 'Upper confidence level (84%) of effective temperature from GSP-Phot Aeneas for A library using BP/RP spectra [K]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters_supp.logg_gspphot_a IS 'Surface gravity from GSP-Phot Aeneas for A library using BP/RP spectra [log(cm.s**-2)]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters_supp.logg_gspphot_a_lower IS 'Lower confidence level (16%) of surface gravity from GSP-Phot Aeneas for A library using BP/RP spectra [log(cm.s**-2)]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters_supp.logg_gspphot_a_upper IS 'Upper confidence level (84%) of surface gravity from GSP-Phot Aeneas for A library using BP/RP spectra [log(cm.s**-2)]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters_supp.mh_gspphot_a IS 'Iron abundance from GSP-Phot Aeneas for A library using BP/RP spectra [''dex'']';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters_supp.mh_gspphot_a_lower IS 'Lower confidence level (16%) of iron abundance from GSP-Phot Aeneas for A library using BP/RP spectra [''dex'']';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters_supp.mh_gspphot_a_upper IS 'Upper confidence level (84%) of iron abundance from GSP-Phot Aeneas for A library using BP/RP spectra [''dex'']';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters_supp.distance_gspphot_a IS 'Distance from GSP-Phot Aeneas for A library using BP/RP spectra [pc]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters_supp.distance_gspphot_a_lower IS 'Lower confidence level (16%) of distance from GSP-Phot Aeneas for A library using BP/RP spectra [pc]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters_supp.distance_gspphot_a_upper IS 'Upper confidence level (84%) of distance from GSP-Phot Aeneas for A library using BP/RP spectra [pc]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters_supp.azero_gspphot_a IS 'Monochromatic extinction $A_0$ at 547.7nm from GSP-Phot Aeneas for A library using BP/RP spectra [mag]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters_supp.azero_gspphot_a_lower IS 'Lower confidence level (16%) of monochromatic extinction $A_0$ at 547.7nm from GSP-Phot Aeneas for A library using BP/RP spectra [mag]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters_supp.azero_gspphot_a_upper IS 'Upper confidence level (84%) of monochromatic extinction $A_0$ at 547.7nm from GSP-Phot Aeneas for A library using BP/RP spectra [mag]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters_supp.ag_gspphot_a IS 'Extinction in G band from GSP-Phot Aeneas for A library using BP/RP spectra [mag]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters_supp.ag_gspphot_a_lower IS 'Lower confidence level (16%) of extinction in G band from GSP-Phot Aeneas for A library using BP/RP spectra [mag]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters_supp.ag_gspphot_a_upper IS 'Upper confidence level (84%) of extinction in G band from GSP-Phot Aeneas for A library using BP/RP spectra [mag]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters_supp.abp_gspphot_a IS 'Extinction in $G_{BP}$ band from GSP-Phot Aeneas for A library using BP/RP spectra [mag]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters_supp.abp_gspphot_a_lower IS 'Lower confidence level (16%) of extinction in $G_{BP}$ band from GSP-Phot Aeneas for A library using BP/RP spectra [mag]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters_supp.abp_gspphot_a_upper IS 'Upper confidence level (84%) of extinction in $G_{BP}$ band from GSP-Phot Aeneas for A library using BP/RP spectra [mag]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters_supp.arp_gspphot_a IS 'Extinction in $G_{RP}$ band from GSP-Phot Aeneas for A library using BP/RP spectra [mag]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters_supp.arp_gspphot_a_lower IS 'Lower confidence level (16%) of extinction in $G_{RP}$ band from GSP-Phot Aeneas for A library using BP/RP spectra [mag]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters_supp.arp_gspphot_a_upper IS 'Upper confidence level (84%) of extinction in $G_{RP}$ band from GSP-Phot Aeneas for A library using BP/RP spectra [mag]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters_supp.ebpminrp_gspphot_a IS 'Reddening $E(BP-RP)$ from GSP-Phot Aeneas for A library using BP/RP spectra [mag]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters_supp.ebpminrp_gspphot_a_lower IS 'Lower confidence level (16%) of reddening $E(BP-RP)$ from GSP-Phot Aeneas for A library using BP/RP spectra [mag]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters_supp.ebpminrp_gspphot_a_upper IS 'Upper confidence level (84%) of reddening $E(BP-RP)$ from GSP-Phot Aeneas for A library using BP/RP spectra [mag]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters_supp.mg_gspphot_a IS 'Absolute magnitude $M_G$ from GSP-Phot Aeneas for A library using BP/RP spectra [mag]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters_supp.mg_gspphot_a_lower IS 'Lower confidence level (16%) of absolute magnitude $M_G$ from GSP-Phot Aeneas for A library using BP/RP spectra [mag]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters_supp.mg_gspphot_a_upper IS 'Upper confidence level (84%) of absolute magnitude $M_G$ from GSP-Phot Aeneas for A library using BP/RP spectra [mag]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters_supp.radius_gspphot_a IS 'Radius from GSP-Phot Aeneas for A library using BP/RP spectra [solRad]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters_supp.radius_gspphot_a_lower IS 'Lower confidence level (16%) of radius from GSP-Phot Aeneas for A library using BP/RP spectra [solRad]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters_supp.radius_gspphot_a_upper IS 'Upper confidence level (84%) of radius from GSP-Phot Aeneas for A library using BP/RP spectra [solRad]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters_supp.logposterior_gspphot_a IS 'Goodness-of-fit score (mean log-posterior of MCMC) of GSP-Phot Aeneas MCMC for A library';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters_supp.mcmcaccept_gspphot_a IS 'MCMC acceptance rate of GSP-Phot Aeneas MCMC for A library';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters_supp.teff_gspspec_ann IS 'Effective temperature from GSP-Spec ANN using RVS spectra and Monte Carlo realisations [K]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters_supp.teff_gspspec_ann_lower IS 'Lower confidence level (16%) of effective temperature from GSP-Spec ANN using RVS spectra and Monte Carlo realisations [K]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters_supp.teff_gspspec_ann_upper IS 'Upper confidence level (84%) of effective temperature from GSP-Spec ANN using RVS spectra and Monte Carlo realisations [K]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters_supp.logg_gspspec_ann IS 'Surface gravity from GSP-Spec ANN using RVS spectra and Monte Carlo realisations [log(cm.s**-2)]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters_supp.logg_gspspec_ann_lower IS 'Lower confidence level (16%) of surface gravity from GSP-Spec ANN using RVS spectra and Monte Carlo realisations [log(cm.s**-2)]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters_supp.logg_gspspec_ann_upper IS 'Upper confidence level (84%) of surface gravity from GSP-Spec ANN using RVS spectra and Monte Carlo realisations [log(cm.s**-2)]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters_supp.mh_gspspec_ann IS 'Global metallicity from GSP-Spec ANN using RVS spectra and Monte Carlo realisations [''dex'']';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters_supp.mh_gspspec_ann_lower IS 'Lower confidence level (16%) of global metallicity from GSP-Spec ANN using RVS spectra and Monte Carlo realisations [''dex'']';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters_supp.mh_gspspec_ann_upper IS 'Upper confidence level (84%) of global metallicity from GSP-Spec ANN using RVS spectra and Monte Carlo realisations [''dex'']';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters_supp.alphafe_gspspec_ann IS 'Abundance of alpha-elements with respect to iron from GSP-Spec ANN using RVS spectra and Monte Carlo realisations [''dex'']';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters_supp.alphafe_gspspec_ann_lower IS 'Lower confidence level (16%) of alpha-elements with respect to iron from GSP-Spec ANN using RVS spectra and Monte Carlo realisations [''dex'']';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters_supp.alphafe_gspspec_ann_upper IS 'Upper confidence level (84%) of alpha-elements with respect to iron from GSP-Spec ANN using RVS spectra and Monte Carlo realisations [''dex'']';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters_supp.logchisq_gspspec_ann IS 'Logarithm of the goodness-of-fit for the GSP-Spec ANN parameters';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters_supp.flags_gspspec_ann IS 'Catalogue flags for GSP-Spec ANN';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters_supp.radius_flame_spec IS 'Radius of the star from FLAME using {\tt teffGspspec} and {\tt lumFlameSpec} [solRad]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters_supp.radius_flame_spec_lower IS 'Lower confidence level (16%) of {\tt radiusFlameSpec} [solRad]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters_supp.radius_flame_spec_upper IS 'Upper confidence level (84%) of {\tt radiusFlameSpec} [solRad]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters_supp.lum_flame_spec IS 'Luminosity of the star from FLAME using G band magnitude, extinction ({\tt agGspphot}), parallax and a bolometric correction {\tt bcFlameSpec} [solLum]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters_supp.lum_flame_spec_lower IS 'Lower confidence level (16%) of {\tt lumFlameSpec} [solLum]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters_supp.lum_flame_spec_upper IS 'Upper confidence level (84%) of {\tt lumFlameSpec} [solLum]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters_supp.mass_flame_spec IS 'Mass of the star from FLAME using stellar models, {\tt lumFlameSpec} and {\tt teffGspspec} [solMass]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters_supp.mass_flame_spec_lower IS 'Lower confidence level (16%) of {\tt massFlameSpec} [solMass]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters_supp.mass_flame_spec_upper IS 'Upper confidence level (84%) of {\tt massFlameSpec} [solMass]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters_supp.age_flame_spec IS 'Age of the star from FLAME using stellar models, see {\tt massFlameSpec} for details [Gyr]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters_supp.age_flame_spec_lower IS 'Lower confidence level (16%) of {\tt ageFlameSpec} [Gyr]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters_supp.age_flame_spec_upper IS 'Upper confidence level (84%) of {\tt ageFlameSpec} [Gyr]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters_supp.flags_flame_spec IS 'Flag indicating quality of parameters from FLAME using GSP-Spec parameters';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters_supp.evolstage_flame_spec IS 'Evolutionary stage of the star from FLAME using stellar models, see {\tt massFlameSpec} for details';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters_supp.gravredshift_flame_spec IS 'Gravitational redshift from FLAME using GSP-Spec parameters [km.s**-1]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters_supp.gravredshift_flame_spec_lower IS 'Lower confidence interval of {\tt gravredshiftFlameSpec} [km.s**-1]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters_supp.gravredshift_flame_spec_upper IS 'Upper confidence interval of {\tt gravredshiftFlameSpec} [km.s**-1]';
COMMENT ON COLUMN gaiadr3.astrophysical_parameters_supp.bc_flame_spec IS 'Bolometric correction applied to derive {\tt lumFlameSpec} using GSP-Spec parameters [mag]';
CREATE INDEX IF NOT EXISTS gaiadr3_astrophysical_parameters_supp_source_id_idx ON gaiadr3.astrophysical_parameters_supp (source_id);

-- [Parámetros astrofísicos] gaiadr3.mcmc_samples_gsp_phot — acceso: DataLink (MCMC_GSPPHOT)
CREATE TABLE IF NOT EXISTS gaiadr3.mcmc_samples_gsp_phot (
    solution_id bigint,
    source_id bigint,
    nsamples smallint,
    teff real[],
    azero real[],
    logg real[],
    mh real[],
    ag real[],
    mg real[],
    distancepc real[],
    abp real[],
    arp real[],
    ebpminrp real[],
    log_pos real[],
    log_lik real[],
    radius real[]
);
COMMENT ON TABLE gaiadr3.mcmc_samples_gsp_phot IS 'This is the DataLink table hosting Monte-Carlo Markov Chain (MCMC) samples for the posterior probability distribution of all parameters derived from the General Stellar Parametrizer from Photometry (GSP-Phot, see Section~\ref{ssec:cu8par_apsis_gspphot} in the online documentation). 2000 MCMC samples are provided for 1) all sources brighter than G=12, 2) a random subset of 0.1\% of the sources fainter than G=12. For all other sources fainter than G=12, the sample size is 100 (the last 100 samples in the MCMC). The table considers the following parameters: \begin{itemize} \item effective temperature $T_{\rm eff}$ in K \item monochromatic extinction at 547.7~nm $A_0$ in mag \item surface gravity $\log g$ \item metallicity [M/H] \item $G$-band extinction in mag \item absolute magnitude $M_{\rm G}$ in mag \item distance in pc \item $G_{\rm BP}$ band extinction $A_{\rm BP}$ in mag \item $G_{\rm RP}$ band extinction $A_{\rm RP}$ in mag \item reddening $E(G_{\rm BP} - G_{\rm RP}) = A_{\rm BP} - A_{\rm RP}$ in mag \item logarithmic posterior probability \item logarithmic likelihood \item stellar radius in $R_\odot$ \end{itemize} Note this table is not available through the main archive TAP interface. Data are delivered via the Massive Data service indexed by the VO Datalink protocol and described in Chapter~\ref{chap:archive}. For example this can be actioned in the archive user interface by querying the main source catalogue {\tt GaiaSource} and selecting {\tt hasMcmcGspphot}~{\tt = ''t''}.';
COMMENT ON COLUMN gaiadr3.mcmc_samples_gsp_phot.solution_id IS 'Solution Identifier';
COMMENT ON COLUMN gaiadr3.mcmc_samples_gsp_phot.source_id IS 'Unique source identifier (unique within a particular Data Release)';
COMMENT ON COLUMN gaiadr3.mcmc_samples_gsp_phot.nsamples IS 'Number of samples in the chain from GSP-Phot';
COMMENT ON COLUMN gaiadr3.mcmc_samples_gsp_phot.teff IS 'MCMC samples for $T_{\rm eff}$ from GSP-Phot [K]';
COMMENT ON COLUMN gaiadr3.mcmc_samples_gsp_phot.azero IS 'MCMC samples for extinction $A_0$ from GSP-Phot [mag]';
COMMENT ON COLUMN gaiadr3.mcmc_samples_gsp_phot.logg IS 'MCMC samples for $\\log g$ from GSP-Phot [log(cm.s**-2)]';
COMMENT ON COLUMN gaiadr3.mcmc_samples_gsp_phot.mh IS 'MCMC samples for the metallicity from GSP-Phot [''dex'']';
COMMENT ON COLUMN gaiadr3.mcmc_samples_gsp_phot.ag IS 'MCMC samples for extinction in G band from GSP-Phot [mag]';
COMMENT ON COLUMN gaiadr3.mcmc_samples_gsp_phot.mg IS 'MCMC samples for $M_{\rm G}$ from GSP-Phot [mag]';
COMMENT ON COLUMN gaiadr3.mcmc_samples_gsp_phot.distancepc IS 'MCMC samples for distance from GSP-Phot [pc]';
COMMENT ON COLUMN gaiadr3.mcmc_samples_gsp_phot.abp IS 'MCMC samples for extinction in $G_{\rm BP}$ band from GSP-Phot [mag]';
COMMENT ON COLUMN gaiadr3.mcmc_samples_gsp_phot.arp IS 'MCMC samples for extinction in $G_{\rm RP}$ band from GSP-Phot [mag]';
COMMENT ON COLUMN gaiadr3.mcmc_samples_gsp_phot.ebpminrp IS 'MCMC samples for reddening $E(G_{\rm BP} - G_{\rm RP})$ from GSP-Phot [mag]';
COMMENT ON COLUMN gaiadr3.mcmc_samples_gsp_phot.log_pos IS 'MCMC samples for the log-posterior from GSP-Phot';
COMMENT ON COLUMN gaiadr3.mcmc_samples_gsp_phot.log_lik IS 'MCMC samples for the log-likelihood from GSP-Phot';
COMMENT ON COLUMN gaiadr3.mcmc_samples_gsp_phot.radius IS 'MCMC samples for stellar radius from GSP-Phot [solRad]';
CREATE INDEX IF NOT EXISTS gaiadr3_mcmc_samples_gsp_phot_source_id_idx ON gaiadr3.mcmc_samples_gsp_phot (source_id);

-- [Parámetros astrofísicos] gaiadr3.mcmc_samples_msc — acceso: DataLink (MCMC_MSC)
CREATE TABLE IF NOT EXISTS gaiadr3.mcmc_samples_msc (
    source_id bigint,
    solution_id bigint,
    nsamples smallint,
    teff1 real[],
    teff2 real[],
    logg1 real[],
    logg2 real[],
    azero real[],
    mh real[],
    distancepc real[],
    log_pos real[],
    log_lik real[]
);
COMMENT ON TABLE gaiadr3.mcmc_samples_msc IS 'This is the DataLink table hosting Monte-Carlo Markov Chain (MCMC) samples for the posterior probability distribution of all parameters derived from the Multiple Source Classifier (MSC, see Section~\ref{ssec:cu8par_apsis_msc} in the online documentation). 100 random MCMC samples are provided for each source. The table considers the following parameters: \begin{itemize} \item effective temperature $T_{\rm eff, 1}$ of the primary star \item effective temperature $T_{\rm eff, 2}$ of the secondary star \item surface gravity $\log g_1$ of the primary star \item surface gravity $\log g_2$ of the secondary star \item monochromatic extinction at 547.7~nm $A_0$ \item metallicity [M/H] \item distance \item logarithmic posterior probability \item logarithmic likelihood \end{itemize} Note this table is not available through the main archive TAP interface. Data are delivered via the Massive Data service indexed by the VO Datalink protocol and described in Chapter~\ref{chap:archive}. For example this can be actioned in the archive user interface by querying the main source catalogue {\tt GaiaSource} and selecting {\tt hasMcmcMsc}~{\tt = ''t''}.';
COMMENT ON COLUMN gaiadr3.mcmc_samples_msc.source_id IS 'Unique source identifier (unique within a particular Data Release)';
COMMENT ON COLUMN gaiadr3.mcmc_samples_msc.solution_id IS 'Solution Identifier';
COMMENT ON COLUMN gaiadr3.mcmc_samples_msc.nsamples IS 'Number of samples in the chain from MSC';
COMMENT ON COLUMN gaiadr3.mcmc_samples_msc.teff1 IS 'MCMC samples for $T_{\rm eff, 1}$ of primary from MSC [K]';
COMMENT ON COLUMN gaiadr3.mcmc_samples_msc.teff2 IS 'MCMC samples for $T_{\rm eff, 2}$ of secondary from MSC [K]';
COMMENT ON COLUMN gaiadr3.mcmc_samples_msc.logg1 IS 'MCMC samples for $\\log g_1$ of primary from MSC [log(cm.s**-2)]';
COMMENT ON COLUMN gaiadr3.mcmc_samples_msc.logg2 IS 'MCMC samples for $\\log g_2$ of secondary from MSC [log(cm.s**-2)]';
COMMENT ON COLUMN gaiadr3.mcmc_samples_msc.azero IS 'MCMC samples for extinction $A_0$ from MSC [mag]';
COMMENT ON COLUMN gaiadr3.mcmc_samples_msc.mh IS 'MCMC samples for the metallicity from MSC [''dex'']';
COMMENT ON COLUMN gaiadr3.mcmc_samples_msc.distancepc IS 'MCMC samples for distance from MSC [pc]';
COMMENT ON COLUMN gaiadr3.mcmc_samples_msc.log_pos IS 'MCMC samples for the log-posterior from MSC';
COMMENT ON COLUMN gaiadr3.mcmc_samples_msc.log_lik IS 'MCMC samples for the log-likelihood from MSC';
CREATE INDEX IF NOT EXISTS gaiadr3_mcmc_samples_msc_source_id_idx ON gaiadr3.mcmc_samples_msc (source_id);

-- [Parámetros astrofísicos] gaiadr3.oa_neuron_information — acceso: TAP Gaia (ADQL)
CREATE TABLE IF NOT EXISTS gaiadr3.oa_neuron_information (
    solution_id bigint,
    som_id bigint,
    neuron_id bigint,
    neuron_row_index smallint,
    neuron_column_index smallint,
    hits integer,
    class_label text,
    centroid_id bigint,
    centroid_distance real,
    template_distance real,
    g_mag_mean real,
    g_mag_std_dev real,
    g_mag_min real,
    g_mag_max real,
    bp_mag_mean real,
    bp_mag_std_dev real,
    bp_mag_min real,
    bp_mag_max real,
    rp_mag_mean real,
    rp_mag_std_dev real,
    rp_mag_min real,
    rp_mag_max real,
    pm_ra_mean real,
    pm_ra_std_dev real,
    pm_ra_min real,
    pm_ra_max real,
    pm_dec_mean real,
    pm_dec_std_dev real,
    pm_dec_min real,
    pm_dec_max real,
    parallax_mean real,
    parallax_std_dev real,
    parallax_min real,
    parallax_max real,
    gal_latitude_mean real,
    gal_latitude_std_dev real,
    gal_latitude_min real,
    gal_latitude_max real,
    intra_neuron_distance_mean real,
    intra_neuron_distance_std_dev real,
    intra_neuron_distance_min real,
    intra_neuron_distance_max real,
    inter_neuron_distance_mean real,
    inter_neuron_distance_std_dev real,
    inter_neuron_distance_min real,
    inter_neuron_distance_max real,
    template_name text,
    distance_percentile25 real,
    distance_percentile50 real,
    distance_percentile68 real,
    distance_percentile75 real,
    distance_percentile95 real,
    distance_fwhm real,
    distance_skew real,
    distance_kurtosis real,
    distance_i_q_r real,
    distance_fwhm_norm real,
    quality_category smallint,
    bp_transits_mean real,
    bp_transits_std_dev real,
    bp_transits_min real,
    bp_transits_max real,
    rp_transits_mean real,
    rp_transits_std_dev real,
    rp_transits_min real,
    rp_transits_max real,
    ruwe_mean real,
    ruwe_std_dev real,
    ruwe_min real,
    ruwe_max real,
    bprp_mean_flux_excess_mean real,
    bprp_mean_flux_excess_std_dev real,
    bprp_mean_flux_excess_min real,
    bprp_mean_flux_excess_max real,
    bprp_colour_mean real,
    bprp_colour_std_dev real,
    bprp_colour_min real,
    bprp_colour_max real
);
COMMENT ON TABLE gaiadr3.oa_neuron_information IS 'This is the table hosting the content of a Self-Organized Map calculated from a dataset composed by outliers by the Apsis module OA. Each entry corresponds to parameters estimated for one particular neuron of the map. The prototype BP/RP spectrum for a particular neuron is available in another table: {\tt OaNeuronXpSpectra}. See Section~\ref{ssec:cu8par_apsis_oa} for further details.';
COMMENT ON COLUMN gaiadr3.oa_neuron_information.solution_id IS 'Solution Identifier';
COMMENT ON COLUMN gaiadr3.oa_neuron_information.som_id IS 'Self-Organized Map identifier';
COMMENT ON COLUMN gaiadr3.oa_neuron_information.neuron_id IS 'Neuron identifier';
COMMENT ON COLUMN gaiadr3.oa_neuron_information.neuron_row_index IS 'Row index of the neuron in the Self-Organised Map lattice';
COMMENT ON COLUMN gaiadr3.oa_neuron_information.neuron_column_index IS 'Column index of the neuron in the Self-Organised Map lattice';
COMMENT ON COLUMN gaiadr3.oa_neuron_information.hits IS 'Number of sources populating the neuron';
COMMENT ON COLUMN gaiadr3.oa_neuron_information.class_label IS 'Astronomical class estimated for the neuron';
COMMENT ON COLUMN gaiadr3.oa_neuron_information.centroid_id IS 'Identifier of the Gaia source that minimizes the classification distance to the neuron';
COMMENT ON COLUMN gaiadr3.oa_neuron_information.centroid_distance IS 'Squared Euclidean distance between the centroid XP spectrum and the neuron XP prototype';
COMMENT ON COLUMN gaiadr3.oa_neuron_information.template_distance IS 'Squared Euclidean distance between the reference XP template and the neuron XP prototype';
COMMENT ON COLUMN gaiadr3.oa_neuron_information.g_mag_mean IS 'Mean $G$ value for the sources that belong to the neuron [mag]';
COMMENT ON COLUMN gaiadr3.oa_neuron_information.g_mag_std_dev IS 'Standard deviation of $G$ values for the sources that belong to the neuron [mag]';
COMMENT ON COLUMN gaiadr3.oa_neuron_information.g_mag_min IS 'Minimum $G$ value for the sources that belong to the neuron [mag]';
COMMENT ON COLUMN gaiadr3.oa_neuron_information.g_mag_max IS 'Maximum $G$ value for the sources that belong to the neuron [mag]';
COMMENT ON COLUMN gaiadr3.oa_neuron_information.bp_mag_mean IS 'Mean $G_{\rm BP}$ value for the sources that belong to the neuron [mag]';
COMMENT ON COLUMN gaiadr3.oa_neuron_information.bp_mag_std_dev IS 'Standard deviation of $G_{\rm BP}$ values for the sources that belong to the neuron [mag]';
COMMENT ON COLUMN gaiadr3.oa_neuron_information.bp_mag_min IS 'Minimum value of $G_{\rm BP}$ for the sources that belong to the neuron [mag]';
COMMENT ON COLUMN gaiadr3.oa_neuron_information.bp_mag_max IS 'Maximum value of $G_{\rm BP}$ for the sources that belong to the neuron [mag]';
COMMENT ON COLUMN gaiadr3.oa_neuron_information.rp_mag_mean IS 'Mean $G_{\rm RP}$ value for the sources that belong to the neuron neuron [mag]';
COMMENT ON COLUMN gaiadr3.oa_neuron_information.rp_mag_std_dev IS 'Standard deviation of $G_{\rm RP}$ values for the sources that belong to the neuron [mag]';
COMMENT ON COLUMN gaiadr3.oa_neuron_information.rp_mag_min IS 'Minimum value of $G_{\rm RP}$ for the sources that belong to the neuron [mag]';
COMMENT ON COLUMN gaiadr3.oa_neuron_information.rp_mag_max IS 'Maximum value of $G_{\rm RP}$ for the sources that belong to the neuron [mag]';
COMMENT ON COLUMN gaiadr3.oa_neuron_information.pm_ra_mean IS 'Mean value of the proper motion in right ascension for the sources that belong to the neuron [mas.yr**-1]';
COMMENT ON COLUMN gaiadr3.oa_neuron_information.pm_ra_std_dev IS 'Standard deviation of the proper motion in right ascension for the sources that belong to the neuron [mas.yr**-1]';
COMMENT ON COLUMN gaiadr3.oa_neuron_information.pm_ra_min IS 'Minimum value of the proper motion in right ascension for the sources that belong to the neuron [mas.yr**-1]';
COMMENT ON COLUMN gaiadr3.oa_neuron_information.pm_ra_max IS 'Maximum value of the proper motion in right ascension for the sources that belong to the neuron [mas.yr**-1]';
COMMENT ON COLUMN gaiadr3.oa_neuron_information.pm_dec_mean IS 'Mean value of the proper motion in declination for the sources that belong to the neuron [mas.yr**-1]';
COMMENT ON COLUMN gaiadr3.oa_neuron_information.pm_dec_std_dev IS 'Standard deviation of the proper motion in declination for the sources that belong to the neuron [mas.yr**-1]';
COMMENT ON COLUMN gaiadr3.oa_neuron_information.pm_dec_min IS 'Minimum value of the proper motion in declination for the sources that belong to the neuron [mas.yr**-1]';
COMMENT ON COLUMN gaiadr3.oa_neuron_information.pm_dec_max IS 'Maximum value of the proper motion in declination for the sources that belong to the neuron [mas.yr**-1]';
COMMENT ON COLUMN gaiadr3.oa_neuron_information.parallax_mean IS 'Mean parallax value for the sources that belong to the neuron [mas]';
COMMENT ON COLUMN gaiadr3.oa_neuron_information.parallax_std_dev IS 'Standard deviation of the parallax values for the sources that belong to the neuron [mas]';
COMMENT ON COLUMN gaiadr3.oa_neuron_information.parallax_min IS 'Minimum parallax value for the sources that belong to the neuron [mas]';
COMMENT ON COLUMN gaiadr3.oa_neuron_information.parallax_max IS 'Maximum parallax value for the sources that belong to the neuron [mas]';
COMMENT ON COLUMN gaiadr3.oa_neuron_information.gal_latitude_mean IS 'Mean galactic latitude for the sources that belong to the neuron [deg]';
COMMENT ON COLUMN gaiadr3.oa_neuron_information.gal_latitude_std_dev IS 'Standard deviation of the galactic latitude values for the sources that belong to the neuron [deg]';
COMMENT ON COLUMN gaiadr3.oa_neuron_information.gal_latitude_min IS 'Minimum galactic latitude for the sources that belong to the neuron [deg]';
COMMENT ON COLUMN gaiadr3.oa_neuron_information.gal_latitude_max IS 'Maximum galactic latitude for the sources that belong to the neuron [deg]';
COMMENT ON COLUMN gaiadr3.oa_neuron_information.intra_neuron_distance_mean IS 'Mean value of the squared Euclidean distance between each of the XP sources in the neuron and the neuron prototype';
COMMENT ON COLUMN gaiadr3.oa_neuron_information.intra_neuron_distance_std_dev IS 'Standard deviation of the squared Euclidean distance between each of the XP sources in the neuron and the neuron prototype';
COMMENT ON COLUMN gaiadr3.oa_neuron_information.intra_neuron_distance_min IS 'Minimum squared Euclidean distance between each of the XP sources in the neuron and the neuron prototype';
COMMENT ON COLUMN gaiadr3.oa_neuron_information.intra_neuron_distance_max IS 'Maximum squared Euclidean distance between each of the XP sources in the neuron and the neuron prototype';
COMMENT ON COLUMN gaiadr3.oa_neuron_information.inter_neuron_distance_mean IS 'Mean value of the squared Euclidean distance between the neuron XP prototype and the XP prototypes of its immediate neighbours';
COMMENT ON COLUMN gaiadr3.oa_neuron_information.inter_neuron_distance_std_dev IS 'Standard deviation of the squared Euclidean distance between the neuron XP prototype and the XP prototypes of its immediate neighbours';
COMMENT ON COLUMN gaiadr3.oa_neuron_information.inter_neuron_distance_min IS 'Minimum value of the squared Euclidean distance between the neuron XP prototype and the XP prototypes of its immediate neighbours';
COMMENT ON COLUMN gaiadr3.oa_neuron_information.inter_neuron_distance_max IS 'Maximum value of the squared Euclidean distance between the neuron XP prototype and the XP prototypes of its immediate neighbours';
COMMENT ON COLUMN gaiadr3.oa_neuron_information.template_name IS 'Name of the template used to describe the neuron';
COMMENT ON COLUMN gaiadr3.oa_neuron_information.distance_percentile25 IS '25th percentile value for the intra-neuron distance distribution';
COMMENT ON COLUMN gaiadr3.oa_neuron_information.distance_percentile50 IS '50th percentile value for the intra-neuron distance distribution';
COMMENT ON COLUMN gaiadr3.oa_neuron_information.distance_percentile68 IS '68th percentile value for the intra-neuron distance distribution';
COMMENT ON COLUMN gaiadr3.oa_neuron_information.distance_percentile75 IS '75th percentile value for the intra-neuron distance distribution';
COMMENT ON COLUMN gaiadr3.oa_neuron_information.distance_percentile95 IS '95th percentile value for the intra-neuron distance distribution';
COMMENT ON COLUMN gaiadr3.oa_neuron_information.distance_fwhm IS 'Full Width at Half Maximum value for the intra-neuron distance distribution';
COMMENT ON COLUMN gaiadr3.oa_neuron_information.distance_skew IS 'Skewness value for the intra-neuron distance distribution';
COMMENT ON COLUMN gaiadr3.oa_neuron_information.distance_kurtosis IS 'Kurtosis value for the intra-neuron distance distribution';
COMMENT ON COLUMN gaiadr3.oa_neuron_information.distance_i_q_r IS 'Inter-Quartile Range value for the intra-neuron distance distribution';
COMMENT ON COLUMN gaiadr3.oa_neuron_information.distance_fwhm_norm IS 'Normalized FWHM value for the intra-neuron distance distribution';
COMMENT ON COLUMN gaiadr3.oa_neuron_information.quality_category IS 'Quality category assigned to the neuron, where 0 corresponds to the most homogeneous neurons and 6 to the most heterogeneous ones';
COMMENT ON COLUMN gaiadr3.oa_neuron_information.bp_transits_mean IS 'Mean value of the number of BP transits for the sources that belong to the neuron';
COMMENT ON COLUMN gaiadr3.oa_neuron_information.bp_transits_std_dev IS 'Standard deviation of the number of BP transits for the sources that belong to the neuron';
COMMENT ON COLUMN gaiadr3.oa_neuron_information.bp_transits_min IS 'Minimum value of the number of BP transits for the sources that belong to the neuron';
COMMENT ON COLUMN gaiadr3.oa_neuron_information.bp_transits_max IS 'Maximum value of the number of BP transits for the sources that belong to the neuron';
COMMENT ON COLUMN gaiadr3.oa_neuron_information.rp_transits_mean IS 'Mean value of the number of RP transits for the sources that belong to the neuron';
COMMENT ON COLUMN gaiadr3.oa_neuron_information.rp_transits_std_dev IS 'Standard deviation of the number of RP transits for the sources that belong to the neuron';
COMMENT ON COLUMN gaiadr3.oa_neuron_information.rp_transits_min IS 'Minimum value of the number of RP transits for the sources that belong to the neuron';
COMMENT ON COLUMN gaiadr3.oa_neuron_information.rp_transits_max IS 'Maximum value of the number of RP transits for the sources that belong to the neuron';
COMMENT ON COLUMN gaiadr3.oa_neuron_information.ruwe_mean IS 'Mean value of the renormalised unit weight error for the sources that belong to the neuron';
COMMENT ON COLUMN gaiadr3.oa_neuron_information.ruwe_std_dev IS 'Standard deviation of the renormalised unit weight error for the sources that belong to the neuron';
COMMENT ON COLUMN gaiadr3.oa_neuron_information.ruwe_min IS 'Minimum value of the renormalised unit weight error for the sources that belong to the neuron';
COMMENT ON COLUMN gaiadr3.oa_neuron_information.ruwe_max IS 'Maximum value of the renormalised unit weight error for the sources that belong to the neuron';
COMMENT ON COLUMN gaiadr3.oa_neuron_information.bprp_mean_flux_excess_mean IS 'Mean value of the BP/RP flux excess for the sources that belong to the neuron';
COMMENT ON COLUMN gaiadr3.oa_neuron_information.bprp_mean_flux_excess_std_dev IS 'Standard deviation of the BP/RP flux excess for the sources that belong to the neuron';
COMMENT ON COLUMN gaiadr3.oa_neuron_information.bprp_mean_flux_excess_min IS 'Minimum value of the BP/RP flux excess for the sources that belong to the neuron';
COMMENT ON COLUMN gaiadr3.oa_neuron_information.bprp_mean_flux_excess_max IS 'Maximum value of the BP/RP flux excess for the sources that belong to the neuron';
COMMENT ON COLUMN gaiadr3.oa_neuron_information.bprp_colour_mean IS 'Mean value of the $G_{\rm BP}-G_{\rm RP}$ colour for the sources that belong to the neuron [mag]';
COMMENT ON COLUMN gaiadr3.oa_neuron_information.bprp_colour_std_dev IS 'Standard deviation of the $G_{\rm BP}-G_{\rm RP}$ colour for the sources that belong to the neuron [mag]';
COMMENT ON COLUMN gaiadr3.oa_neuron_information.bprp_colour_min IS 'Minimum value of the $G_{\rm BP}-G_{\rm RP}$ colour for the sources that belong to the neuron [mag]';
COMMENT ON COLUMN gaiadr3.oa_neuron_information.bprp_colour_max IS 'Maximum value of the $G_{\rm BP}-G_{\rm RP}$ colour for the sources that belong to the neuron [mag]';

-- [Parámetros astrofísicos] gaiadr3.oa_neuron_xp_spectra — acceso: TAP Gaia (ADQL)
CREATE TABLE IF NOT EXISTS gaiadr3.oa_neuron_xp_spectra (
    solution_id bigint,
    neuron_id bigint,
    neuron_row_index smallint,
    neuron_column_index smallint,
    xp_spectrum_prototype_flux real,
    xp_spectrum_prototype_wavelength real,
    xp_spectrum_template_flux real
);
COMMENT ON TABLE gaiadr3.oa_neuron_xp_spectra IS 'This is the table hosting the prototype BP/RP spectrum corresponding to each of the neurons of the Self-Organised-Map produced by the Apsis module OA. Other neuron attributes, such as statistics on various parameters, are available in another table: {\tt OaNeuronInformation}. See Section~\ref{ssec:cu8par_apsis_oa} for further details.';
COMMENT ON COLUMN gaiadr3.oa_neuron_xp_spectra.solution_id IS 'Solution Identifier';
COMMENT ON COLUMN gaiadr3.oa_neuron_xp_spectra.neuron_id IS 'Neuron identifier';
COMMENT ON COLUMN gaiadr3.oa_neuron_xp_spectra.neuron_row_index IS 'Row index of the neuron in the Self-Organised Map lattice';
COMMENT ON COLUMN gaiadr3.oa_neuron_xp_spectra.neuron_column_index IS 'Column index of the neuron in the Self-Organised Map lattice';
COMMENT ON COLUMN gaiadr3.oa_neuron_xp_spectra.xp_spectrum_prototype_flux IS 'Normalised flux at wavelength {\tt xpSpectrumPrototypeWavelength} for the preprocessed XP spectrum that best represents the neuron (prototype)';
COMMENT ON COLUMN gaiadr3.oa_neuron_xp_spectra.xp_spectrum_prototype_wavelength IS 'Wavelength associated with the XP spectrum flux values [nm]';
COMMENT ON COLUMN gaiadr3.oa_neuron_xp_spectra.xp_spectrum_template_flux IS 'Normalised flux at wavelength {\tt xpSpectrumPrototypeWavelength} for the preprocessed XP spectrum corresponding to the neuron template';

-- [Parámetros astrofísicos] gaiadr3.total_galactic_extinction_map — acceso: TAP Gaia (ADQL)
CREATE TABLE IF NOT EXISTS gaiadr3.total_galactic_extinction_map (
    solution_id bigint,
    healpix_id bigint,
    healpix_level smallint,
    a0 real,
    a0_uncertainty real,
    a0_min real,
    a0_max real,
    num_tracers_used integer,
    optimum_hpx_flag boolean,
    status smallint
);
COMMENT ON TABLE gaiadr3.total_galactic_extinction_map IS 'This table provides the Total Galactic Extinction (TGE) map for extinction parameters $A_0$ describing the effective total Galactic extinction and related uncertainties at four separate HEALPix levels, namely levels 6 to 9. For further details see Section \ref{ssec:cu8par_apsis_tge} of the online documentation.';
COMMENT ON COLUMN gaiadr3.total_galactic_extinction_map.solution_id IS 'Solution Identifier';
COMMENT ON COLUMN gaiadr3.total_galactic_extinction_map.healpix_id IS 'HEALPix identification';
COMMENT ON COLUMN gaiadr3.total_galactic_extinction_map.healpix_level IS 'HEALPix level used';
COMMENT ON COLUMN gaiadr3.total_galactic_extinction_map.a0 IS 'Mean $A_0$ extinction parameter [mag]';
COMMENT ON COLUMN gaiadr3.total_galactic_extinction_map.a0_uncertainty IS 'Uncertainty for the mean $A_0$ [mag]';
COMMENT ON COLUMN gaiadr3.total_galactic_extinction_map.a0_min IS 'Minimum $A_0$ value used for the HEALPix of interest [mag]';
COMMENT ON COLUMN gaiadr3.total_galactic_extinction_map.a0_max IS 'Maximum $A_0$ value used for the HEALPix of interest [mag]';
COMMENT ON COLUMN gaiadr3.total_galactic_extinction_map.num_tracers_used IS 'Number of tracers used';
COMMENT ON COLUMN gaiadr3.total_galactic_extinction_map.optimum_hpx_flag IS 'Flag to indicate whether a given HEALPix level is the optimum (True) or not (False)';
COMMENT ON COLUMN gaiadr3.total_galactic_extinction_map.status IS 'Exit status for TGE';

-- [Parámetros astrofísicos] gaiadr3.total_galactic_extinction_map_opt — acceso: TAP Gaia (ADQL)
CREATE TABLE IF NOT EXISTS gaiadr3.total_galactic_extinction_map_opt (
    solution_id bigint,
    healpix_id bigint,
    a0 real,
    a0_uncertainty real,
    num_tracers_used integer,
    status smallint,
    optimum_hpx_level smallint
);
COMMENT ON TABLE gaiadr3.total_galactic_extinction_map_opt IS 'This table provides an optimum version of the Total Galactic Extinction map, derived from the table {{TotalGalacticExtinctionMap}} at a single HEALPix level 9. For this, the mean effective total Galactic extinction and related uncertainties have been selected from the optimal HEALPix level of the four offered in {{TotalGalacticExtinctionMap}}. For further details see Section \ref{ssec:cu8par_apsis_tge} of the online documentation.';
COMMENT ON COLUMN gaiadr3.total_galactic_extinction_map_opt.solution_id IS 'Solution Identifier';
COMMENT ON COLUMN gaiadr3.total_galactic_extinction_map_opt.healpix_id IS 'HEALPix identification';
COMMENT ON COLUMN gaiadr3.total_galactic_extinction_map_opt.a0 IS 'Median A$_0$ extinction parameter [mag]';
COMMENT ON COLUMN gaiadr3.total_galactic_extinction_map_opt.a0_uncertainty IS 'Uncertainty for the mean A$_0$ [mag]';
COMMENT ON COLUMN gaiadr3.total_galactic_extinction_map_opt.num_tracers_used IS 'Number of tracers used';
COMMENT ON COLUMN gaiadr3.total_galactic_extinction_map_opt.status IS 'Exit status for TGE';
COMMENT ON COLUMN gaiadr3.total_galactic_extinction_map_opt.optimum_hpx_level IS 'Number indicating which HEALPix level was chosen to populate this HEALPix';

-- [Cruce con catálogos externos] gaiadr3.allwise_best_neighbour — acceso: TAP Gaia (ADQL)
CREATE TABLE IF NOT EXISTS gaiadr3.allwise_best_neighbour (
    source_id bigint,
    original_ext_source_id text,
    angular_distance real,
    xm_flag smallint,
    allwise_oid integer,
    number_of_neighbours smallint,
    number_of_mates smallint
);
COMMENT ON TABLE gaiadr3.allwise_best_neighbour IS '<p>allWISE BestNeighbour table lists each matched Gaia object with its best neighbour in the external catalogue. The cross-match algorithm is not symmetric and searches Gaia sources counterparts in allWISE.<br/> The best neighbour is chosen among good neighbours as the one with the highest value of the figure of merit, which evaluates the ratio between two opposite models/hypotheses: the counterpart candidate is a match or it is found by chance. Good neighbours are nearby objects in the external catalogue whose position is compatible within position errors with the Gaia target.<br/> The cross-match algorithm is positional and exploits the full 5 parameters covariance matrix of Gaia astrometric solution when available and the external catalogue positions and position errors. In addition it takes into account the external catalogue environment using the local density.<br/> <br/> Please note that the cross-match algorithm is a trade-off between multiple requirements, in particular between completeness and correctness. It is thus not limited to a simple cone search.<br/> <br/> Reference papers:<br/> </p> <p>DR1-DPACP-17<br/> </p> <p>DR2-DPACP-41<br/> </p>';
COMMENT ON COLUMN gaiadr3.allwise_best_neighbour.source_id IS 'Unique Gaia source identifier';
COMMENT ON COLUMN gaiadr3.allwise_best_neighbour.original_ext_source_id IS 'Original External Catalogue source identifier';
COMMENT ON COLUMN gaiadr3.allwise_best_neighbour.angular_distance IS 'Angular Distance between the two sources [arcsec]';
COMMENT ON COLUMN gaiadr3.allwise_best_neighbour.xm_flag IS 'Cross-match algorithm flag';
COMMENT ON COLUMN gaiadr3.allwise_best_neighbour.allwise_oid IS 'External Catalogue source identifier';
COMMENT ON COLUMN gaiadr3.allwise_best_neighbour.number_of_neighbours IS 'Number of neighbours in External Catalogue';
COMMENT ON COLUMN gaiadr3.allwise_best_neighbour.number_of_mates IS 'Number of mates in Gaia Catalogue';
CREATE INDEX IF NOT EXISTS gaiadr3_allwise_best_neighbour_source_id_idx ON gaiadr3.allwise_best_neighbour (source_id);

-- [Cruce con catálogos externos] gaiadr3.allwise_neighbourhood — acceso: TAP Gaia (ADQL)
CREATE TABLE IF NOT EXISTS gaiadr3.allwise_neighbourhood (
    source_id bigint,
    original_ext_source_id text,
    angular_distance real,
    score double precision,
    xm_flag smallint,
    allwise_oid integer
);
COMMENT ON TABLE gaiadr3.allwise_neighbourhood IS '<p>allWISE Neighbourhood table includes all good neighbours for each matched Gaia object. A good neighbour for a given Gaia source is a nearby object in the external catalogue whose position is compatible (within position errors) with the Gaia target. <br/> The cross-match algorithm is not symmetric and searches Gaia sources counterparts in allWISE. The cross-match algorithm is positional and exploits the full 5 parameters covariance matrix of Gaia astrometric solution when available and the external catalogue positions and position errors. In addition it takes into account the external catalogue environment using the local density.<br/> <br/> Please note that the cross-match algorithm is a trade-off between multiple requirements, in particular between completeness and correctness. It is thus not limited to a simple cone search.<br/> <br/> Reference papers:<br/> </p> <p>DR1-DPACP-17<br/> </p> <p>DR2-DPACP-41<br/> </p>';
COMMENT ON COLUMN gaiadr3.allwise_neighbourhood.source_id IS 'Unique Gaia source identifier';
COMMENT ON COLUMN gaiadr3.allwise_neighbourhood.original_ext_source_id IS 'Original External Catalogue source identifier';
COMMENT ON COLUMN gaiadr3.allwise_neighbourhood.angular_distance IS 'Angular Distance between the two sources [arcsec]';
COMMENT ON COLUMN gaiadr3.allwise_neighbourhood.score IS 'Score of neighbours';
COMMENT ON COLUMN gaiadr3.allwise_neighbourhood.xm_flag IS 'Cross-match algorithm flag';
COMMENT ON COLUMN gaiadr3.allwise_neighbourhood.allwise_oid IS 'External Catalogue source identifier';
CREATE INDEX IF NOT EXISTS gaiadr3_allwise_neighbourhood_source_id_idx ON gaiadr3.allwise_neighbourhood (source_id);

-- [Cruce con catálogos externos] gaiadr3.apassdr9_best_neighbour — acceso: TAP Gaia (ADQL)
CREATE TABLE IF NOT EXISTS gaiadr3.apassdr9_best_neighbour (
    source_id bigint,
    clean_apassdr9_oid bigint,
    original_ext_source_id bigint,
    angular_distance double precision,
    number_of_neighbours integer,
    number_of_mates smallint,
    xm_flag integer
);
COMMENT ON TABLE gaiadr3.apassdr9_best_neighbour IS '<p>Table <tt>Apassdr9BestNeighbour</tt> lists each matched Gaia object with its best neighbour in the external catalogue. The cross-match algorithm is not symmetric and searches Gaia sources counterparts in APASS DR9. The best neighbour is chosen among good neighbours as the one with the highest value of the figure of merit, which evaluates the ratio between two opposite models/hypotheses: the counterpart candidate is a match or it is found by chance. Good neighbours are nearby objects in the external catalogue whose position is compatible within position errors with the Gaia target. The cross-match algorithm is positional and exploits the full&#160;5 parameter covariance matrix of Gaia astrometric solution when available and the external catalogue positions and position errors. In addition it takes into account the external catalogue environment using the local density.</p> <p>Please note that the cross-match algorithm is a trade-off between multiple requirements, in particular between completeness and correctness. It is thus not limited to a simple cone search.</p> <p>Reference papers:<br/> </p> <p>DR1-DPACP-17<br/> </p> <p>DR2-DPACP-41<br/> </p>';
COMMENT ON COLUMN gaiadr3.apassdr9_best_neighbour.source_id IS 'Unique Gaia source identifier';
COMMENT ON COLUMN gaiadr3.apassdr9_best_neighbour.clean_apassdr9_oid IS 'External Catalogue source identifier';
COMMENT ON COLUMN gaiadr3.apassdr9_best_neighbour.original_ext_source_id IS 'Original External Catalogue source identifier';
COMMENT ON COLUMN gaiadr3.apassdr9_best_neighbour.angular_distance IS 'Angular Distance between the two sources [arcsec]';
COMMENT ON COLUMN gaiadr3.apassdr9_best_neighbour.number_of_neighbours IS 'Number of neighbours in External Catalogue';
COMMENT ON COLUMN gaiadr3.apassdr9_best_neighbour.number_of_mates IS 'Number of mates in Gaia Catalogue';
COMMENT ON COLUMN gaiadr3.apassdr9_best_neighbour.xm_flag IS 'Cross-match algorithm flag';
CREATE INDEX IF NOT EXISTS gaiadr3_apassdr9_best_neighbour_source_id_idx ON gaiadr3.apassdr9_best_neighbour (source_id);

-- [Cruce con catálogos externos] gaiadr3.apassdr9_join — acceso: TAP Gaia (ADQL)
CREATE TABLE IF NOT EXISTS gaiadr3.apassdr9_join (
    original_ext_source_id bigint,
    clean_apassdr9_oid integer
);
COMMENT ON TABLE gaiadr3.apassdr9_join IS 'Convenience table to be used to join the APASS DR9 catalogue with the cross-match results. The table links the external catalogue original sourceId (originalExtSourceId) to the corresponding additional numerical identifier (cleanApassdr9Oid). Both originalExtSourceId and cleanApassdr9Oid are present in the cross-match output tables (Apassdr9BestNeighbour and Apassdr9Neighbourhood). However, in case there are suspected duplicates in the external catalogue, different originalExtSourceId will correspond to the same cleanApassdr9Oid. In the cross-match output table only the originalExtSourceId of the source with the best astrometry among the suspected duplicates will be listed. In practice, users may use the originalExtSourceId in the original catalogue to find the matching source with the best astrometry. Users interested in all matching suspected duplicates should instead use the cleanApassdr9Oid in the join with the cross-match result tables. See Chapter [chap:crossmatch] for more details on the duplicates in the external catalogues and their treatment in the cross-match computations.';
COMMENT ON COLUMN gaiadr3.apassdr9_join.original_ext_source_id IS 'Original External Catalogue source identifier';
COMMENT ON COLUMN gaiadr3.apassdr9_join.clean_apassdr9_oid IS 'External Catalogue source identifier';

-- [Cruce con catálogos externos] gaiadr3.apassdr9_neighbourhood — acceso: TAP Gaia (ADQL)
CREATE TABLE IF NOT EXISTS gaiadr3.apassdr9_neighbourhood (
    source_id bigint,
    clean_apassdr9_oid bigint,
    original_ext_source_id bigint,
    angular_distance double precision,
    score double precision,
    xm_flag integer
);
COMMENT ON TABLE gaiadr3.apassdr9_neighbourhood IS '<p>Table <tt>Apassdr9Neighbourhood</tt> includes all good neighbours for each matched Gaia object. A good neighbour for a given Gaia source is a nearby object in the external catalogue whose position is compatible (within position errors) with the Gaia target. The cross-match algorithm is not symmetric and searches Gaia sources counterparts in APASS DR9. The cross-match algorithm is positional and exploits the full&#160;5 parameter covariance matrix of the the Gaia astrometric solution when available and the external catalogue positions and position errors. In addition it takes into account the external catalogue environment using the local density.</p> <p>Please note that the cross-match algorithm is a trade-off between multiple requirements, in particular between completeness and correctness. It is thus not limited to a simple cone search.</p> <p>Reference papers:<br/> </p> <p>DR1-DPACP-17<br/> </p> <p>DR2-DPACP-41<br/> </p>';
COMMENT ON COLUMN gaiadr3.apassdr9_neighbourhood.source_id IS 'Unique Gaia source identifier';
COMMENT ON COLUMN gaiadr3.apassdr9_neighbourhood.clean_apassdr9_oid IS 'External Catalogue source identifier';
COMMENT ON COLUMN gaiadr3.apassdr9_neighbourhood.original_ext_source_id IS 'Original External Catalogue source identifier';
COMMENT ON COLUMN gaiadr3.apassdr9_neighbourhood.angular_distance IS 'Angular Distance between the two sources [arcsec]';
COMMENT ON COLUMN gaiadr3.apassdr9_neighbourhood.score IS 'Score of neighbours';
COMMENT ON COLUMN gaiadr3.apassdr9_neighbourhood.xm_flag IS 'Cross-match algorithm flag';
CREATE INDEX IF NOT EXISTS gaiadr3_apassdr9_neighbourhood_source_id_idx ON gaiadr3.apassdr9_neighbourhood (source_id);

-- [Cruce con catálogos externos] gaiadr3.dr2_neighbourhood — acceso: TAP Gaia (ADQL)
CREATE TABLE IF NOT EXISTS gaiadr3.dr2_neighbourhood (
    dr2_source_id bigint,
    dr3_source_id bigint,
    angular_distance real,
    magnitude_difference real,
    proper_motion_propagation boolean
);
COMMENT ON TABLE gaiadr3.dr2_neighbourhood IS 'Users wishing to look up the E/DR3 record for an astrophysical source identified in DR2 must NOT simply extract the record from E/DR3 having the same source identifier. As described in the detailed description of attribute designation in GaiaSource it is not guaranteed that the same astronomical source will always have the same source identifier in different Data Releases. Hence the only safe way to compare source records between different Data Releases in general is to check the records of proximal source(s) in the same small part of the sky. This table provides the means to do this via a precomputed crossmatch of such sources, taking into account the proper motions available at E/DR3. Within the neighbourhood of a given E/DR3 source there may be none, one or (rarely) several possible counterparts in DR2 indicated by rows in this table. This occasional source confusion is an inevitable consequence of the merging, splitting and deletion of identifiers introduced in previous releases during the DR3 processing and results in no guaranteed one–to–one correspondence in source identifiers between the releases. For more details of the procedure used to create this crossmatch, see Chapter [chap:archive] in the online documentation.';
COMMENT ON COLUMN gaiadr3.dr2_neighbourhood.dr2_source_id IS 'Source identifier in Gaia DR2';
COMMENT ON COLUMN gaiadr3.dr2_neighbourhood.dr3_source_id IS 'Source identifier in Gaia E/DR3';
COMMENT ON COLUMN gaiadr3.dr2_neighbourhood.angular_distance IS 'Angular distance between the two sources [mas]';
COMMENT ON COLUMN gaiadr3.dr2_neighbourhood.magnitude_difference IS 'G band magnitude difference between the sources [mag]';
COMMENT ON COLUMN gaiadr3.dr2_neighbourhood.proper_motion_propagation IS 'Flag indicating whether E/DR3 coordinates were proper motion corrected';

-- [Cruce con catálogos externos] gaiadr3.gsc23_best_neighbour — acceso: TAP Gaia (ADQL)
CREATE TABLE IF NOT EXISTS gaiadr3.gsc23_best_neighbour (
    source_id bigint,
    original_ext_source_id text,
    angular_distance real,
    xm_flag smallint,
    clean_gsc23_oid integer,
    number_of_neighbours smallint,
    number_of_mates smallint
);
COMMENT ON TABLE gaiadr3.gsc23_best_neighbour IS '<p>GSC2.3 BestNeighbour table lists each matched Gaia object with its best neighbour in the external catalogue. The cross-match algorithm is not symmetric and searches Gaia sources counterparts in GSC2.3.<br/> The best neighbour is chosen among good neighbours as the one with the highest value of the figure of merit, which evaluates the ratio between two opposite models/hypotheses: the counterpart candidate is a match or it is found by chance. Good neighbours are nearby objects in the external catalogue whose position is compatible within position errors with the Gaia target.<br/> The cross-match algorithm is positional and exploits the full 5 parameters covariance matrix of Gaia astrometric solution when available and the external catalogue positions and position errors. In addition it takes into account the external catalogue environment using the local density.<br/> <br/> Please note that the cross-match algorithm is a trade-off between multiple requirements, in particular between completeness and correctness. It is thus not limited to a simple cone search.<br/> <br/> Reference papers:<br/> </p> <p>DR1-DPACP-17<br/> </p> <p>DR2-DPACP-41<br/> </p>';
COMMENT ON COLUMN gaiadr3.gsc23_best_neighbour.source_id IS 'Unique Gaia source identifier';
COMMENT ON COLUMN gaiadr3.gsc23_best_neighbour.original_ext_source_id IS 'Original External Catalogue source identifier';
COMMENT ON COLUMN gaiadr3.gsc23_best_neighbour.angular_distance IS 'Angular Distance between the two sources [arcsec]';
COMMENT ON COLUMN gaiadr3.gsc23_best_neighbour.xm_flag IS 'Cross-match algorithm flag';
COMMENT ON COLUMN gaiadr3.gsc23_best_neighbour.clean_gsc23_oid IS 'External Catalogue source identifier';
COMMENT ON COLUMN gaiadr3.gsc23_best_neighbour.number_of_neighbours IS 'Number of neighbours in External Catalogue';
COMMENT ON COLUMN gaiadr3.gsc23_best_neighbour.number_of_mates IS 'Number of mates in Gaia Catalogue';
CREATE INDEX IF NOT EXISTS gaiadr3_gsc23_best_neighbour_source_id_idx ON gaiadr3.gsc23_best_neighbour (source_id);

-- [Cruce con catálogos externos] gaiadr3.gsc23_join — acceso: TAP Gaia (ADQL)
CREATE TABLE IF NOT EXISTS gaiadr3.gsc23_join (
    original_ext_source_id text,
    clean_gsc23_oid integer
);
COMMENT ON TABLE gaiadr3.gsc23_join IS 'Convenience table to be used to join GSC 2.3 catalogue with the cross-match results. The table links the external catalogue original sourceId (originalExtSourceId) to the corresponding the additional numerical identifier (cleanGsc23Oid). Both originalExtSourceId and cleanGsc23Oid are present in the cross-match output tables (gsc23BestNeighbour and gsc23Neighbourhood). However, in case there are suspected duplicates in the external catalogue, different originalExtSourceId will correspond to the same cleanGsc23Oid. In the cross-match output table only the originalExtSourceId of the source with the best astrometry among the suspected duplicates will be listed. In practice, users may use the originalExtSourceId in the original catalogue to find the matching source with the best astrometry. Users interested to find all matching suspected duplicates should instead use the cleanGsc23Oid in the join with the cross-match result tables. See Documentation, [chap:crossmatch], for more details on the duplicates in the external catalogues and their treatment in the cross-match computations.';
COMMENT ON COLUMN gaiadr3.gsc23_join.original_ext_source_id IS 'Original External Catalogue source identifier';
COMMENT ON COLUMN gaiadr3.gsc23_join.clean_gsc23_oid IS 'External Catalogue source identifier';

-- [Cruce con catálogos externos] gaiadr3.gsc23_neighbourhood — acceso: TAP Gaia (ADQL)
CREATE TABLE IF NOT EXISTS gaiadr3.gsc23_neighbourhood (
    source_id bigint,
    original_ext_source_id text,
    angular_distance real,
    score double precision,
    xm_flag smallint,
    clean_gsc23_oid integer
);
COMMENT ON TABLE gaiadr3.gsc23_neighbourhood IS '<p>GSC2.3 Neighbourhood table includes all good neighbours for each matched Gaia object. A good neighbour for a given Gaia source is a nearby object in the external catalogue whose position is compatible (within position errors) with the Gaia target. <br/> The cross-match algorithm is not symmetric and searches Gaia sources counterparts in GSC2.3. The cross-match algorithm is positional and exploits the full 5 parameters covariance matrix of Gaia astrometric solution when available and the external catalogue positions and position errors. In addition it takes into account the external catalogue environment using the local density.<br/> <br/> Please note that the cross-match algorithm is a trade-off between multiple requirements, in particular between completeness and correctness. It is thus not limited to a simple cone search.<br/> <br/> Reference papers:<br/> </p> <p>DR1-DPACP-17<br/> </p> <p>DR2-DPACP-41<br/> </p>';
COMMENT ON COLUMN gaiadr3.gsc23_neighbourhood.source_id IS 'Unique Gaia source identifier';
COMMENT ON COLUMN gaiadr3.gsc23_neighbourhood.original_ext_source_id IS 'Original External Catalogue source identifier';
COMMENT ON COLUMN gaiadr3.gsc23_neighbourhood.angular_distance IS 'Angular Distance between the two sources [arcsec]';
COMMENT ON COLUMN gaiadr3.gsc23_neighbourhood.score IS 'Score of neighbours';
COMMENT ON COLUMN gaiadr3.gsc23_neighbourhood.xm_flag IS 'Cross-match algorithm flag';
COMMENT ON COLUMN gaiadr3.gsc23_neighbourhood.clean_gsc23_oid IS 'External Catalogue source identifier';
CREATE INDEX IF NOT EXISTS gaiadr3_gsc23_neighbourhood_source_id_idx ON gaiadr3.gsc23_neighbourhood (source_id);

-- [Cruce con catálogos externos] gaiadr3.hipparcos2_best_neighbour — acceso: TAP Gaia (ADQL)
CREATE TABLE IF NOT EXISTS gaiadr3.hipparcos2_best_neighbour (
    source_id bigint,
    original_ext_source_id integer,
    angular_distance real,
    number_of_neighbours smallint,
    xm_flag smallint
);
COMMENT ON TABLE gaiadr3.hipparcos2_best_neighbour IS '<p>Hipparcos2 BestNeighbour table lists each matched external catalogue object with its best neighbour in Gaia. The cross-match algorithm is not symmetric and searches Hipparcos2 sources counterparts in Gaia.<br/> The best neighbour is chosen among good neighbours as the one with the highest value of the figure of merit, which evaluates the ratio between two opposite models/hypotheses: the counterpart candidate is a match or it is found by chance. Good neighbours are nearby objects in Gaia whose position is compatible within position errors with the external catalogue target.<br/> The cross-match algorithm is positional and exploits the full 5 parameters covariance matrix of Gaia astrometric solution when available and the external catalogue positions and position errors. In addition it takes into account the Gaia environment using the local density.<br/> <br/> Please note that the cross-match algorithm is a trade-off between multiple requirements, in particular between completeness and correctness. It is thus not limited to a simple cone search.<br/> <br/> Reference papers:<br/> </p> <p>DR1-DPACP-17<br/> </p> <p>DR2-DPACP-41<br/> </p>';
COMMENT ON COLUMN gaiadr3.hipparcos2_best_neighbour.source_id IS 'Unique Gaia source identifier';
COMMENT ON COLUMN gaiadr3.hipparcos2_best_neighbour.original_ext_source_id IS 'Original External Catalogue source identifier';
COMMENT ON COLUMN gaiadr3.hipparcos2_best_neighbour.angular_distance IS 'Angular Distance between the two sources [arcsec]';
COMMENT ON COLUMN gaiadr3.hipparcos2_best_neighbour.number_of_neighbours IS 'Number of neighbours in Gaia Catalogue';
COMMENT ON COLUMN gaiadr3.hipparcos2_best_neighbour.xm_flag IS 'Cross-match algorithm flag';
CREATE INDEX IF NOT EXISTS gaiadr3_hipparcos2_best_neighbour_source_id_idx ON gaiadr3.hipparcos2_best_neighbour (source_id);

-- [Cruce con catálogos externos] gaiadr3.hipparcos2_neighbourhood — acceso: TAP Gaia (ADQL)
CREATE TABLE IF NOT EXISTS gaiadr3.hipparcos2_neighbourhood (
    source_id bigint,
    original_ext_source_id integer,
    angular_distance real,
    score double precision,
    xm_flag smallint
);
COMMENT ON TABLE gaiadr3.hipparcos2_neighbourhood IS '<p>Hipparcos2 Neighbourhood table includes all good neighbours for each matched Hipparcos2 object. A good neighbour for a given Hipparcos2 source is a nearby Gaia object whose position is compatible (within position errors) with the Hipparcos2 target. <br/> The cross-match algorithm is not symmetric and searches Hipparcos2 sources counterparts in Gaia. The cross-match algorithm is positional and exploits the full 5 parameters covariance matrix of Gaia astrometric solution when available and the external catalogue positions and position errors. In addition it takes into account the Gaia environment using the local density.<br/> <br/> Please note that the cross-match algorithm is a trade-off between multiple requirements, in particular between completeness and correctness. It is thus not limited to a simple cone search.<br/> <br/> Reference papers:<br/> </p> <p>DR1-DPACP-17<br/> </p> <p>DR2-DPACP-41<br/> </p>';
COMMENT ON COLUMN gaiadr3.hipparcos2_neighbourhood.source_id IS 'Unique Gaia source identifier';
COMMENT ON COLUMN gaiadr3.hipparcos2_neighbourhood.original_ext_source_id IS 'Original External Catalogue source identifier';
COMMENT ON COLUMN gaiadr3.hipparcos2_neighbourhood.angular_distance IS 'Angular Distance between the two sources [arcsec]';
COMMENT ON COLUMN gaiadr3.hipparcos2_neighbourhood.score IS 'Score of neighbours';
COMMENT ON COLUMN gaiadr3.hipparcos2_neighbourhood.xm_flag IS 'Cross-match algorithm flag';
CREATE INDEX IF NOT EXISTS gaiadr3_hipparcos2_neighbourhood_source_id_idx ON gaiadr3.hipparcos2_neighbourhood (source_id);

-- [Cruce con catálogos externos] gaiadr3.panstarrs1_best_neighbour — acceso: TAP Gaia (ADQL)
CREATE TABLE IF NOT EXISTS gaiadr3.panstarrs1_best_neighbour (
    source_id bigint,
    clean_panstarrs1_oid bigint,
    original_ext_source_id bigint,
    angular_distance real,
    number_of_neighbours smallint,
    number_of_mates smallint,
    xm_flag smallint
);
COMMENT ON TABLE gaiadr3.panstarrs1_best_neighbour IS '<p>Pan-STARRS1 DR1 BestNeighbour table lists each matched Gaia object with its best neighbour in the external catalogue. The cross-match algorithm is not symmetric and searches Gaia sources counterparts in Pan-STARRS1 DR1.<br/> The best neighbour is chosen among good neighbours as the one with the highest value of the figure of merit, which evaluates the ratio between two opposite models/hypotheses: the counterpart candidate is a match or it is found by chance. Good neighbours are nearby objects in the external catalogue whose position is compatible within position errors with the Gaia target.<br/> The cross-match algorithm is positional and exploits the full 5 parameters covariance matrix of Gaia astrometric solution when available and the external catalogue positions and position errors. In addition it takes into account the external catalogue environment using the local density.<br/> <br/> Please note that the cross-match algorithm is a trade-off between multiple requirements, in particular between completeness and correctness. It is thus not limited to a simple cone search.<br/> <br/> Reference papers:<br/> </p> <p>DR1-DPACP-17<br/> </p> <p>DR2-DPACP-41<br/> </p>';
COMMENT ON COLUMN gaiadr3.panstarrs1_best_neighbour.source_id IS 'Unique Gaia source identifier';
COMMENT ON COLUMN gaiadr3.panstarrs1_best_neighbour.clean_panstarrs1_oid IS 'External Catalogue source identifier';
COMMENT ON COLUMN gaiadr3.panstarrs1_best_neighbour.original_ext_source_id IS 'Original External Catalogue source identifier';
COMMENT ON COLUMN gaiadr3.panstarrs1_best_neighbour.angular_distance IS 'Angular Distance between the two sources [arcsec]';
COMMENT ON COLUMN gaiadr3.panstarrs1_best_neighbour.number_of_neighbours IS 'Number of neighbours in External Catalogue';
COMMENT ON COLUMN gaiadr3.panstarrs1_best_neighbour.number_of_mates IS 'Number of mates in Gaia Catalogue';
COMMENT ON COLUMN gaiadr3.panstarrs1_best_neighbour.xm_flag IS 'Cross-match algorithm flag';
CREATE INDEX IF NOT EXISTS gaiadr3_panstarrs1_best_neighbour_source_id_idx ON gaiadr3.panstarrs1_best_neighbour (source_id);

-- [Cruce con catálogos externos] gaiadr3.panstarrs1_join — acceso: TAP Gaia (ADQL)
CREATE TABLE IF NOT EXISTS gaiadr3.panstarrs1_join (
    original_ext_source_id bigint,
    clean_panstarrs1_oid bigint
);
COMMENT ON TABLE gaiadr3.panstarrs1_join IS 'Convenience table to be used to join Pan-STARRS1 DR1.1 catalogue with the cross-match results. The table links the external catalogue original sourceId (originalExtSourceId) to the corresponding the additional numerical identifier (cleanPanstarrs1Oid). Both originalExtSourceId and cleanPanstarrs1Oid are present in the cross-match output tables (panstarrs1BestNeighbour and panstarrs1Neighbourhood). However, in case there are suspected duplicates in the external catalogue, different originalExtSourceId will correspond to the same cleanPanstarrs1Oid. In the cross-match output table only the originalExtSourceId of the source with the best astrometry among the suspected duplicates will be listed. In practice, users may use the originalExtSourceId in the original catalogue to find the matching source with the best astrometry. Users interested to find all matching suspected duplicates should instead use the cleanPanstarrs1Oid in the join with the cross-match result tables. See Documentation, [chap:crossmatch], for more details on the duplicates in the external catalogues and their treatment in the cross-match computations.';
COMMENT ON COLUMN gaiadr3.panstarrs1_join.original_ext_source_id IS 'Original External Catalogue source identifier';
COMMENT ON COLUMN gaiadr3.panstarrs1_join.clean_panstarrs1_oid IS 'External Catalogue source identifier';

-- [Cruce con catálogos externos] gaiadr3.panstarrs1_neighbourhood — acceso: TAP Gaia (ADQL)
CREATE TABLE IF NOT EXISTS gaiadr3.panstarrs1_neighbourhood (
    source_id bigint,
    clean_panstarrs1_oid bigint,
    original_ext_source_id bigint,
    angular_distance real,
    score double precision,
    xm_flag smallint
);
COMMENT ON TABLE gaiadr3.panstarrs1_neighbourhood IS '<p>Pan-STARRS1 DR1 Neighbourhood table includes all good neighbours for each matched Gaia object. A good neighbour for a given Gaia source is a nearby object in the external catalogue whose position is compatible (within position errors) with the Gaia target. <br/> The cross-match algorithm is not symmetric and searches Gaia sources counterparts in Pan-STARRS1 DR1. The cross-match algorithm is positional and exploits the full 5 parameters covariance matrix of Gaia astrometric solution when available and the external catalogue positions and position errors. In addition it takes into account the external catalogue environment using the local density.<br/> <br/> Please note that the cross-match algorithm is a trade-off between multiple requirements, in particular between completeness and correctness. It is thus not limited to a simple cone search.<br/> <br/> Reference papers:<br/> </p> <p>DR1-DPACP-17<br/> </p> <p>DR2-DPACP-41<br/> </p>';
COMMENT ON COLUMN gaiadr3.panstarrs1_neighbourhood.source_id IS 'Unique Gaia source identifier';
COMMENT ON COLUMN gaiadr3.panstarrs1_neighbourhood.clean_panstarrs1_oid IS 'External Catalogue source identifier';
COMMENT ON COLUMN gaiadr3.panstarrs1_neighbourhood.original_ext_source_id IS 'Original External Catalogue source identifier';
COMMENT ON COLUMN gaiadr3.panstarrs1_neighbourhood.angular_distance IS 'Angular Distance between the two sources [arcsec]';
COMMENT ON COLUMN gaiadr3.panstarrs1_neighbourhood.score IS 'Score of neighbours';
COMMENT ON COLUMN gaiadr3.panstarrs1_neighbourhood.xm_flag IS 'Cross-match algorithm flag';
CREATE INDEX IF NOT EXISTS gaiadr3_panstarrs1_neighbourhood_source_id_idx ON gaiadr3.panstarrs1_neighbourhood (source_id);

-- [Cruce con catálogos externos] gaiadr3.ravedr5_best_neighbour — acceso: TAP Gaia (ADQL)
CREATE TABLE IF NOT EXISTS gaiadr3.ravedr5_best_neighbour (
    source_id bigint,
    original_ext_source_id text,
    angular_distance real,
    xm_flag smallint,
    clean_ravedr5_oid integer,
    number_of_neighbours smallint
);
COMMENT ON TABLE gaiadr3.ravedr5_best_neighbour IS '<p>RAVE DR5 BestNeighbour table lists each matched external catalogue object with its best neighbour in Gaia. The cross-match algorithm is not symmetric and searches RAVE DR5 sources counterparts in Gaia.<br/> The best neighbour is chosen among good neighbours as the one with the highest value of the figure of merit, which evaluates the ratio between two opposite models/hypotheses: the counterpart candidate is a match or it is found by chance. Good neighbours are nearby objects in Gaia whose position is compatible within position errors with the external catalogue target.<br/> The cross-match algorithm is positional and exploits the full 5 parameters covariance matrix of Gaia astrometric solution when available and the external catalogue positions and position errors. In addition it takes into account the Gaia environment using the local density.<br/> <br/> Please note that the cross-match algorithm is a trade-off between multiple requirements, in particular between completeness and correctness. It is thus not limited to a simple cone search.<br/> <br/> Reference papers:<br/> </p> <p>DR1-DPACP-17<br/> </p> <p>DR2-DPACP-41<br/> </p>';
COMMENT ON COLUMN gaiadr3.ravedr5_best_neighbour.source_id IS 'Unique Gaia source identifier';
COMMENT ON COLUMN gaiadr3.ravedr5_best_neighbour.original_ext_source_id IS 'Original External Catalogue source identifier';
COMMENT ON COLUMN gaiadr3.ravedr5_best_neighbour.angular_distance IS 'Angular Distance between the two sources [arcsec]';
COMMENT ON COLUMN gaiadr3.ravedr5_best_neighbour.xm_flag IS 'Cross-match algorithm flag';
COMMENT ON COLUMN gaiadr3.ravedr5_best_neighbour.clean_ravedr5_oid IS 'External Catalogue source identifier';
COMMENT ON COLUMN gaiadr3.ravedr5_best_neighbour.number_of_neighbours IS 'Number of neighbours in Gaia Catalogue';
CREATE INDEX IF NOT EXISTS gaiadr3_ravedr5_best_neighbour_source_id_idx ON gaiadr3.ravedr5_best_neighbour (source_id);

-- [Cruce con catálogos externos] gaiadr3.ravedr5_join — acceso: TAP Gaia (ADQL)
CREATE TABLE IF NOT EXISTS gaiadr3.ravedr5_join (
    original_ext_source_id text,
    clean_ravedr5_oid integer
);
COMMENT ON TABLE gaiadr3.ravedr5_join IS 'Convenience table to be used to join RAVE DR5 catalogue with the cross-match results. The table links the external catalogue original sourceId (originalExtSourceId) to the corresponding the additional numerical identifier (cleanRavedr5Oid). Both originalExtSourceId and cleanRavedr5Oid are present in the cross-match output tables (ravedr5BestNeighbour and ravedr5Neighbourhood). However, in case there are suspected duplicates in the external catalogue, different originalExtSourceId will correspond to the same cleanRavedr5Oid. In the cross-match output table only the originalExtSourceId of the source with the best astrometry among the suspected duplicates will be listed. In practice, users may use the originalExtSourceId in the original catalogue to find the matching source with the best astrometry. Users interested to find all matching suspected duplicates should instead use the cleanRavedr5Oid in the join with the cross-match result tables. See Documentation, [chap:crossmatch], for more details on the duplicates in the external catalogues and their treatment in the cross-match computations.';
COMMENT ON COLUMN gaiadr3.ravedr5_join.original_ext_source_id IS 'Original External Catalogue source identifier';
COMMENT ON COLUMN gaiadr3.ravedr5_join.clean_ravedr5_oid IS 'External Catalogue source identifier';

-- [Cruce con catálogos externos] gaiadr3.ravedr5_neighbourhood — acceso: TAP Gaia (ADQL)
CREATE TABLE IF NOT EXISTS gaiadr3.ravedr5_neighbourhood (
    source_id bigint,
    original_ext_source_id text,
    angular_distance real,
    score double precision,
    xm_flag smallint,
    clean_ravedr5_oid integer
);
COMMENT ON TABLE gaiadr3.ravedr5_neighbourhood IS '<p>RAVE DR5 Neighbourhood table includes all good neighbours for each matched RAVE DR5 object. A good neighbour for a given RAVE DR5 source is a nearby Gaia object whose position is compatible (within position errors) with the RAVE DR5 target. <br/> The cross-match algorithm is not symmetric and searches RAVE DR5 sources counterparts in Gaia. The cross-match algorithm is positional and exploits the full 5 parameters covariance matrix of Gaia astrometric solution when available and the external catalogue positions and position errors. In addition it takes into account the Gaia environment using the local density.<br/> <br/> Please note that the cross-match algorithm is a trade-off between multiple requirements, in particular between completeness and correctness. It is thus not limited to a simple cone search.<br/> <br/> Reference papers:<br/> </p> <p>DR1-DPACP-17<br/> </p> <p>DR2-DPACP-41<br/> </p>';
COMMENT ON COLUMN gaiadr3.ravedr5_neighbourhood.source_id IS 'Unique Gaia source identifier';
COMMENT ON COLUMN gaiadr3.ravedr5_neighbourhood.original_ext_source_id IS 'Original External Catalogue source identifier';
COMMENT ON COLUMN gaiadr3.ravedr5_neighbourhood.angular_distance IS 'Angular Distance between the two sources [arcsec]';
COMMENT ON COLUMN gaiadr3.ravedr5_neighbourhood.score IS 'Score of neighbours';
COMMENT ON COLUMN gaiadr3.ravedr5_neighbourhood.xm_flag IS 'Cross-match algorithm flag';
COMMENT ON COLUMN gaiadr3.ravedr5_neighbourhood.clean_ravedr5_oid IS 'External Catalogue source identifier';
CREATE INDEX IF NOT EXISTS gaiadr3_ravedr5_neighbourhood_source_id_idx ON gaiadr3.ravedr5_neighbourhood (source_id);

-- [Cruce con catálogos externos] gaiadr3.ravedr6_best_neighbour — acceso: TAP Gaia (ADQL)
CREATE TABLE IF NOT EXISTS gaiadr3.ravedr6_best_neighbour (
    source_id bigint,
    original_ext_source_id text,
    angular_distance real,
    xm_flag smallint,
    ravedr6_oid integer,
    number_of_neighbours smallint
);
COMMENT ON TABLE gaiadr3.ravedr6_best_neighbour IS 'Table {\tt Ravedr6BestNeighbour} lists each matched external catalogue object with its best neighbour in Gaia. The cross-match algorithm is not symmetric and searches RAVE DR6 sources counterparts in Gaia. The best neighbour is chosen among good neighbours as the one with the highest value of the figure of merit, which evaluates the ratio between two opposite models/hypotheses: the counterpart candidate is a match or it is found by chance. Good neighbours are nearby objects in Gaia whose position is compatible within position errors with the external catalogue target. The cross-match algorithm is positional and exploits the full~5 parameter covariance matrix of the Gaia astrometric solution when available and the external catalogue positions and position errors. In addition it takes into account the Gaia environment using the local density. Please note that the cross-match algorithm is a trade-off between multiple requirements, in particular between completeness and correctness. It is thus not limited to a simple cone search. Reference papers:\\ \citet{DR1-DPACP-17}\\ \citet{DR2-DPACP-41}\\';
COMMENT ON COLUMN gaiadr3.ravedr6_best_neighbour.source_id IS 'Unique Gaia source identifier';
COMMENT ON COLUMN gaiadr3.ravedr6_best_neighbour.original_ext_source_id IS 'Original External Catalogue source identifier';
COMMENT ON COLUMN gaiadr3.ravedr6_best_neighbour.angular_distance IS 'Angular Distance between the two sources [arcsec]';
COMMENT ON COLUMN gaiadr3.ravedr6_best_neighbour.xm_flag IS 'Cross-match algorithm flag';
COMMENT ON COLUMN gaiadr3.ravedr6_best_neighbour.ravedr6_oid IS 'External Catalogue source identifier';
COMMENT ON COLUMN gaiadr3.ravedr6_best_neighbour.number_of_neighbours IS 'Number of neighbours in Gaia Catalogue';
CREATE INDEX IF NOT EXISTS gaiadr3_ravedr6_best_neighbour_source_id_idx ON gaiadr3.ravedr6_best_neighbour (source_id);

-- [Cruce con catálogos externos] gaiadr3.ravedr6_join — acceso: TAP Gaia (ADQL)
CREATE TABLE IF NOT EXISTS gaiadr3.ravedr6_join (
    original_ext_source_id text,
    ravedr6_oid integer
);
COMMENT ON TABLE gaiadr3.ravedr6_join IS 'Convenience table to be used to join RAVE DR6 catalogue with the cross-match results. The table links the external catalogue original sourceId ({\tt originalExtSourceId}) to the corresponding additional numerical identifier ({\tt ravedr6Oid}). Both {\tt originalExtSourceId} and {\tt ravedr6Oid} are present in the cross-match output tables ({\tt Ravedr6BestNeighbour} and {\tt Ravedr6Neighbourhood}). However, in case there are suspected duplicates in the external catalogue, different {\tt originalExtSourceId} will correspond to the same {\tt ravedr6Oid}. In the cross-match output table only the {\tt originalExtSourceId} of the source with the best astrometry among the suspected duplicates will be listed. In practice, users may use the {\tt originalExtSourceId} in the original catalogue to find the matching source with the best astrometry. Users interested to find all matching suspected duplicates should instead use the {\tt ravedr6Oid} in the join with the cross-match result tables. See Chapter~\ref{chap:crossmatch}, for more details on the duplicates in the external catalogues and their treatment in the cross-match computations.';
COMMENT ON COLUMN gaiadr3.ravedr6_join.original_ext_source_id IS 'Original External Catalogue source identifier';
COMMENT ON COLUMN gaiadr3.ravedr6_join.ravedr6_oid IS 'External Catalogue source identifier';

-- [Cruce con catálogos externos] gaiadr3.ravedr6_neighbourhood — acceso: TAP Gaia (ADQL)
CREATE TABLE IF NOT EXISTS gaiadr3.ravedr6_neighbourhood (
    source_id bigint,
    original_ext_source_id text,
    angular_distance real,
    score double precision,
    xm_flag smallint,
    ravedr6_oid integer
);
COMMENT ON TABLE gaiadr3.ravedr6_neighbourhood IS 'Table {\tt Ravedr6Neighbourhood} includes all good neighbours for each matched RAVE DR6 object. A good neighbour for a given RAVE DR6 source is a nearby Gaia object whose position is compatible (within position errors) with the RAVE DR6 target. The cross-match algorithm is not symmetric and searches RAVE DR6 sources counterparts in Gaia. The cross-match algorithm is positional and exploits the full~5 parameter covariance matrix of the Gaia astrometric solution when available and the external catalogue positions and position errors. In addition it takes into account the Gaia environment using the local density. Please note that the cross-match algorithm is a trade-off between multiple requirements, in particular between completeness and correctness. It is thus not limited to a simple cone search. Reference papers:\\ \citet{DR1-DPACP-17}\\ \citet{DR2-DPACP-41}\\';
COMMENT ON COLUMN gaiadr3.ravedr6_neighbourhood.source_id IS 'Unique Gaia source identifier';
COMMENT ON COLUMN gaiadr3.ravedr6_neighbourhood.original_ext_source_id IS 'Original External Catalogue source identifier';
COMMENT ON COLUMN gaiadr3.ravedr6_neighbourhood.angular_distance IS 'Angular Distance between the two sources [arcsec]';
COMMENT ON COLUMN gaiadr3.ravedr6_neighbourhood.score IS 'Score of neighbours';
COMMENT ON COLUMN gaiadr3.ravedr6_neighbourhood.xm_flag IS 'Cross-match algorithm flag';
COMMENT ON COLUMN gaiadr3.ravedr6_neighbourhood.ravedr6_oid IS 'External Catalogue source identifier';
CREATE INDEX IF NOT EXISTS gaiadr3_ravedr6_neighbourhood_source_id_idx ON gaiadr3.ravedr6_neighbourhood (source_id);

-- [Cruce con catálogos externos] gaiadr3.sdssdr13_best_neighbour — acceso: TAP Gaia (ADQL)
CREATE TABLE IF NOT EXISTS gaiadr3.sdssdr13_best_neighbour (
    source_id bigint,
    clean_sdssdr13_oid integer,
    original_ext_source_id bigint,
    angular_distance real,
    number_of_neighbours smallint,
    number_of_mates smallint,
    xm_flag smallint
);
COMMENT ON TABLE gaiadr3.sdssdr13_best_neighbour IS '<p>SDSS DR13 BestNeighbour table lists each matched Gaia object with its best neighbour in the external catalogue. The cross-match algorithm is not symmetric and searches Gaia sources counterparts in SDSS DR13.<br/> The best neighbour is chosen among good neighbours as the one with the highest value of the figure of merit, which evaluates the ratio between two opposite models/hypotheses: the counterpart candidate is a match or it is found by chance. Good neighbours are nearby objects in the external catalogue whose position is compatible within position errors with the Gaia target.<br/> The cross-match algorithm is positional and exploits the full 5 parameters covariance matrix of Gaia astrometric solution when available and the external catalogue positions and position errors. In addition it takes into account the external catalogue environment using the local density.<br/> <br/> Please note that the cross-match algorithm is a trade-off between multiple requirements, in particular between completeness and correctness. It is thus not limited to a simple cone search.<br/> <br/> Reference papers:<br/> </p> <p>DR1-DPACP-17<br/> </p> <p>DR2-DPACP-41<br/> </p>';
COMMENT ON COLUMN gaiadr3.sdssdr13_best_neighbour.source_id IS 'Unique Gaia source identifier';
COMMENT ON COLUMN gaiadr3.sdssdr13_best_neighbour.clean_sdssdr13_oid IS 'External Catalogue source identifier';
COMMENT ON COLUMN gaiadr3.sdssdr13_best_neighbour.original_ext_source_id IS 'Original External Catalogue source identifier';
COMMENT ON COLUMN gaiadr3.sdssdr13_best_neighbour.angular_distance IS 'Angular Distance between the two sources [arcsec]';
COMMENT ON COLUMN gaiadr3.sdssdr13_best_neighbour.number_of_neighbours IS 'Number of neighbours in External Catalogue';
COMMENT ON COLUMN gaiadr3.sdssdr13_best_neighbour.number_of_mates IS 'Number of mates in Gaia Catalogue';
COMMENT ON COLUMN gaiadr3.sdssdr13_best_neighbour.xm_flag IS 'Cross-match algorithm flag';
CREATE INDEX IF NOT EXISTS gaiadr3_sdssdr13_best_neighbour_source_id_idx ON gaiadr3.sdssdr13_best_neighbour (source_id);

-- [Cruce con catálogos externos] gaiadr3.sdssdr13_join — acceso: TAP Gaia (ADQL)
CREATE TABLE IF NOT EXISTS gaiadr3.sdssdr13_join (
    original_ext_source_id bigint,
    clean_sdssdr13_oid integer
);
COMMENT ON TABLE gaiadr3.sdssdr13_join IS 'Convenience table to be used to join SDSS DR13 catalogue with the cross-match results. The table links the external catalogue original sourceId (originalExtSourceId) to the corresponding the additional numerical identifier (sdssdr13Oid). Both originalExtSourceId and sdssdr13Oid are present in the cross-match output tables (sdssdr13BestNeighbour and sdssdr13Neighbourhood). However, in case there are suspected duplicates in the external catalogue, different originalExtSourceId will correspond to the same sdssdr13Oid. In the cross-match output table only the originalExtSourceId of the source with the best astrometry among the suspected duplicates will be listed. In practice, users may use the originalExtSourceId in the original catalogue to find the matching source with the best astrometry. Users interested to find all matching suspected duplicates should instead use the sdssdr13Oid in the join with the cross-match result tables. See Documentation [chap:crossmatch], for more details on the duplicates in the external catalogues and their treatment in the cross-match computations.';
COMMENT ON COLUMN gaiadr3.sdssdr13_join.original_ext_source_id IS 'Original External Catalogue source identifier';
COMMENT ON COLUMN gaiadr3.sdssdr13_join.clean_sdssdr13_oid IS 'External Catalogue source identifier';

-- [Cruce con catálogos externos] gaiadr3.sdssdr13_neighbourhood — acceso: TAP Gaia (ADQL)
CREATE TABLE IF NOT EXISTS gaiadr3.sdssdr13_neighbourhood (
    source_id bigint,
    clean_sdssdr13_oid integer,
    original_ext_source_id bigint,
    angular_distance real,
    score double precision,
    xm_flag smallint
);
COMMENT ON TABLE gaiadr3.sdssdr13_neighbourhood IS '<p>SDSS DR13 Neighbourhood table includes all good neighbours for each matched Gaia object. A good neighbour for a given Gaia source is a nearby object in the external catalogue whose position is compatible (within position errors) with the Gaia target. <br/> The cross-match algorithm is not symmetric and searches Gaia sources counterparts in SDSS DR13. The cross-match algorithm is positional and exploits the full 5 parameters covariance matrix of Gaia astrometric solution when available and the external catalogue positions and position errors. In addition it takes into account the external catalogue environment using the local density.<br/> <br/> Please note that the cross-match algorithm is a trade-off between multiple requirements, in particular between completeness and correctness. It is thus not limited to a simple cone search.<br/> <br/> Reference papers:<br/> </p> <p>DR1-DPACP-17<br/> </p> <p>DR2-DPACP-41<br/> </p>';
COMMENT ON COLUMN gaiadr3.sdssdr13_neighbourhood.source_id IS 'Unique Gaia source identifier';
COMMENT ON COLUMN gaiadr3.sdssdr13_neighbourhood.clean_sdssdr13_oid IS 'External Catalogue source identifier';
COMMENT ON COLUMN gaiadr3.sdssdr13_neighbourhood.original_ext_source_id IS 'Original External Catalogue source identifier';
COMMENT ON COLUMN gaiadr3.sdssdr13_neighbourhood.angular_distance IS 'Angular Distance between the two sources [arcsec]';
COMMENT ON COLUMN gaiadr3.sdssdr13_neighbourhood.score IS 'Score of neighbours';
COMMENT ON COLUMN gaiadr3.sdssdr13_neighbourhood.xm_flag IS 'Cross-match algorithm flag';
CREATE INDEX IF NOT EXISTS gaiadr3_sdssdr13_neighbourhood_source_id_idx ON gaiadr3.sdssdr13_neighbourhood (source_id);

-- [Cruce con catálogos externos] gaiadr3.skymapperdr2_best_neighbour — acceso: TAP Gaia (ADQL)
CREATE TABLE IF NOT EXISTS gaiadr3.skymapperdr2_best_neighbour (
    source_id bigint,
    original_ext_source_id bigint,
    angular_distance real,
    number_of_neighbours smallint,
    number_of_mates smallint,
    xm_flag smallint
);
COMMENT ON TABLE gaiadr3.skymapperdr2_best_neighbour IS '<p>SkyMapper DR2 BestNeighbour table lists each matched Gaia object with its best neighbour in the external catalogue. The cross-match algorithm is not symmetric and searches Gaia sources counterparts in SkyMapper DR2.<br/> The best neighbour is chosen among good neighbours as the one with the highest value of the figure of merit, which evaluates the ratio between two opposite models/hypotheses: the counterpart candidate is a match or it is found by chance. Good neighbours are nearby objects in the external catalogue whose position is compatible within position errors with the Gaia target.<br/> The cross-match algorithm is positional and exploits the full 5 parameters covariance matrix of Gaia astrometric solution when available and the external catalogue positions and position errors. In addition it takes into account the external catalogue environment using the local density.<br/> <br/> Please note that the cross-match algorithm is a trade-off between multiple requirements, in particular between completeness and correctness. It is thus not limited to a simple cone search.<br/> <br/> Reference papers:<br/> </p> <p>DR1-DPACP-17<br/> </p> <p>DR2-DPACP-41<br/> </p>';
COMMENT ON COLUMN gaiadr3.skymapperdr2_best_neighbour.source_id IS 'Unique Gaia source identifier';
COMMENT ON COLUMN gaiadr3.skymapperdr2_best_neighbour.original_ext_source_id IS 'Original External Catalogue source identifier';
COMMENT ON COLUMN gaiadr3.skymapperdr2_best_neighbour.angular_distance IS 'Angular Distance between the two sources [arcsec]';
COMMENT ON COLUMN gaiadr3.skymapperdr2_best_neighbour.number_of_neighbours IS 'Number of neighbours in External Catalogue';
COMMENT ON COLUMN gaiadr3.skymapperdr2_best_neighbour.number_of_mates IS 'Number of mates in Gaia Catalogue';
COMMENT ON COLUMN gaiadr3.skymapperdr2_best_neighbour.xm_flag IS 'Cross-match algorithm flag';
CREATE INDEX IF NOT EXISTS gaiadr3_skymapperdr2_best_neighbour_source_id_idx ON gaiadr3.skymapperdr2_best_neighbour (source_id);

-- [Cruce con catálogos externos] gaiadr3.skymapperdr2_join — acceso: TAP Gaia (ADQL)
CREATE TABLE IF NOT EXISTS gaiadr3.skymapperdr2_join (
    original_ext_source_id bigint
);
COMMENT ON TABLE gaiadr3.skymapperdr2_join IS 'Convenience table to be used to join SkyMapper DR2 catalogue with the cross-match results. It lists all the SkyMapper DR2 sources which were used in the cross-match. See Documentation, [chap:crossmatch], for more details on the catalogue.';
COMMENT ON COLUMN gaiadr3.skymapperdr2_join.original_ext_source_id IS 'Original External Catalogue source identifier';

-- [Cruce con catálogos externos] gaiadr3.skymapperdr2_neighbourhood — acceso: TAP Gaia (ADQL)
CREATE TABLE IF NOT EXISTS gaiadr3.skymapperdr2_neighbourhood (
    source_id bigint,
    original_ext_source_id bigint,
    angular_distance real,
    score double precision,
    xm_flag smallint
);
COMMENT ON TABLE gaiadr3.skymapperdr2_neighbourhood IS '<p>SkyMapper DR2 Neighbourhood table includes all good neighbours for each matched Gaia object. A good neighbour for a given Gaia source is a nearby object in the external catalogue whose position is compatible (within position errors) with the Gaia target. <br/> The cross-match algorithm is not symmetric and searches Gaia sources counterparts in SkyMapper DR2. The cross-match algorithm is positional and exploits the full 5 parameters covariance matrix of Gaia astrometric solution when available and the external catalogue positions and position errors. In addition it takes into account the external catalogue environment using the local density.<br/> <br/> Please note that the cross-match algorithm is a trade-off between multiple requirements, in particular between completeness and correctness. It is thus not limited to a simple cone search.<br/> <br/> Reference papers:<br/> </p> <p>DR1-DPACP-17<br/> </p> <p>DR2-DPACP-41<br/> </p>';
COMMENT ON COLUMN gaiadr3.skymapperdr2_neighbourhood.source_id IS 'Unique Gaia source identifier';
COMMENT ON COLUMN gaiadr3.skymapperdr2_neighbourhood.original_ext_source_id IS 'Original External Catalogue source identifier';
COMMENT ON COLUMN gaiadr3.skymapperdr2_neighbourhood.angular_distance IS 'Angular Distance between the two sources [arcsec]';
COMMENT ON COLUMN gaiadr3.skymapperdr2_neighbourhood.score IS 'Score of neighbours';
COMMENT ON COLUMN gaiadr3.skymapperdr2_neighbourhood.xm_flag IS 'Cross-match algorithm flag';
CREATE INDEX IF NOT EXISTS gaiadr3_skymapperdr2_neighbourhood_source_id_idx ON gaiadr3.skymapperdr2_neighbourhood (source_id);

-- [Cruce con catálogos externos] gaiadr3.tmass_psc_xsc_best_neighbour — acceso: TAP Gaia (ADQL)
CREATE TABLE IF NOT EXISTS gaiadr3.tmass_psc_xsc_best_neighbour (
    source_id bigint,
    original_ext_source_id text,
    angular_distance real,
    xm_flag smallint,
    clean_tmass_psc_xsc_oid integer,
    number_of_neighbours smallint,
    number_of_mates smallint
);
COMMENT ON TABLE gaiadr3.tmass_psc_xsc_best_neighbour IS '<p>2MASS BestNeighbour table lists each matched Gaia object with its best neighbour in the external catalogue. The cross-match algorithm is not symmetric and searches Gaia sources counterparts in 2MASS.<br/> The best neighbour is chosen among good neighbours as the one with the highest value of the figure of merit, which evaluates the ratio between two opposite models/hypotheses: the counterpart candidate is a match or it is found by chance. Good neighbours are nearby objects in the external catalogue whose position is compatible within position errors with the Gaia target.<br/> The cross-match algorithm is positional and exploits the full 5 parameters covariance matrix of Gaia astrometric solution when available and the external catalogue positions and position errors. In addition it takes into account the external catalogue environment using the local density.<br/> <br/> Please note that the cross-match algorithm is a trade-off between multiple requirements, in particular between completeness and correctness. It is thus not limited to a simple cone search.<br/> <br/> Reference papers:<br/> </p> <p>DR1-DPACP-17<br/> </p> <p>DR2-DPACP-41<br/> </p>';
COMMENT ON COLUMN gaiadr3.tmass_psc_xsc_best_neighbour.source_id IS 'Unique Gaia source identifier';
COMMENT ON COLUMN gaiadr3.tmass_psc_xsc_best_neighbour.original_ext_source_id IS 'Original External Catalogue source identifier';
COMMENT ON COLUMN gaiadr3.tmass_psc_xsc_best_neighbour.angular_distance IS 'Angular Distance between the two sources [arcsec]';
COMMENT ON COLUMN gaiadr3.tmass_psc_xsc_best_neighbour.xm_flag IS 'Cross-match algorithm flag';
COMMENT ON COLUMN gaiadr3.tmass_psc_xsc_best_neighbour.clean_tmass_psc_xsc_oid IS 'External Catalogue source identifier';
COMMENT ON COLUMN gaiadr3.tmass_psc_xsc_best_neighbour.number_of_neighbours IS 'Number of neighbours in External Catalogue';
COMMENT ON COLUMN gaiadr3.tmass_psc_xsc_best_neighbour.number_of_mates IS 'Number of mates in Gaia Catalogue';
CREATE INDEX IF NOT EXISTS gaiadr3_tmass_psc_xsc_best_neighbour_source_id_idx ON gaiadr3.tmass_psc_xsc_best_neighbour (source_id);

-- [Cruce con catálogos externos] gaiadr3.tmass_psc_xsc_join — acceso: TAP Gaia (ADQL)
CREATE TABLE IF NOT EXISTS gaiadr3.tmass_psc_xsc_join (
    original_psc_source_id text,
    original_xsc_source_id text,
    clean_tmass_psc_xsc_oid integer
);
COMMENT ON TABLE gaiadr3.tmass_psc_xsc_join IS 'Convenience table to be used to join 2MASS PSC+XSC catalogue with the cross-match results. The table links the external catalogue original sourceId (originalExtSourceId) to the corresponding the additional numerical identifier (cleanTmassPscXscOid). Both originalExtSourceId and cleanTmassPscXscOid are present in the cross-match output tables (tmassPscXscBestNeighbour and tmassPscXscNeighbourhood). However, in case there are suspected duplicates in the external catalogue, different originalExtSourceId will correspond to the same cleanTmassPscXscOid. In the cross-match output table only the originalExtSourceId of the source with the best astrometry among the suspected duplicates will be listed. In practice, users may use the originalExtSourceId in the original catalogue to find the matching source with the best astrometry. Users interested to find all matching suspected duplicates should instead use the cleanTmassPscXscOid in the join with the cross-match result tables. See Documentation, [chap:crossmatch], for more details on the duplicates in the external catalogues and their treatment in the cross-match computations.';
COMMENT ON COLUMN gaiadr3.tmass_psc_xsc_join.original_psc_source_id IS 'Original 2MASS PSC source identifier';
COMMENT ON COLUMN gaiadr3.tmass_psc_xsc_join.original_xsc_source_id IS 'Original 2MASS XSC source identifier';
COMMENT ON COLUMN gaiadr3.tmass_psc_xsc_join.clean_tmass_psc_xsc_oid IS 'External Catalogue source identifier';

-- [Cruce con catálogos externos] gaiadr3.tmass_psc_xsc_neighbourhood — acceso: TAP Gaia (ADQL)
CREATE TABLE IF NOT EXISTS gaiadr3.tmass_psc_xsc_neighbourhood (
    source_id bigint,
    original_ext_source_id text,
    angular_distance real,
    score double precision,
    xm_flag smallint,
    clean_tmass_psc_xsc_oid integer
);
COMMENT ON TABLE gaiadr3.tmass_psc_xsc_neighbourhood IS '<p>2MASS Neighbourhood table includes all good neighbours for each matched Gaia object. A good neighbour for a given Gaia source is a nearby object in the external catalogue whose position is compatible (within position errors) with the Gaia target. <br/> The cross-match algorithm is not symmetric and searches Gaia sources counterparts in 2MASS. The cross-match algorithm is positional and exploits the full 5 parameters covariance matrix of Gaia astrometric solution when available and the external catalogue positions and position errors. In addition it takes into account the external catalogue environment using the local density.<br/> <br/> Please note that the cross-match algorithm is a trade-off between multiple requirements, in particular between completeness and correctness. It is thus not limited to a simple cone search.<br/> <br/> Reference papers:<br/> </p> <p>DR1-DPACP-17<br/> </p> <p>DR2-DPACP-41<br/> </p>';
COMMENT ON COLUMN gaiadr3.tmass_psc_xsc_neighbourhood.source_id IS 'Unique Gaia source identifier';
COMMENT ON COLUMN gaiadr3.tmass_psc_xsc_neighbourhood.original_ext_source_id IS 'Original External Catalogue source identifier';
COMMENT ON COLUMN gaiadr3.tmass_psc_xsc_neighbourhood.angular_distance IS 'Angular Distance between the two sources [arcsec]';
COMMENT ON COLUMN gaiadr3.tmass_psc_xsc_neighbourhood.score IS 'Score of neighbours';
COMMENT ON COLUMN gaiadr3.tmass_psc_xsc_neighbourhood.xm_flag IS 'Cross-match algorithm flag';
COMMENT ON COLUMN gaiadr3.tmass_psc_xsc_neighbourhood.clean_tmass_psc_xsc_oid IS 'External Catalogue source identifier';
CREATE INDEX IF NOT EXISTS gaiadr3_tmass_psc_xsc_neighbourhood_source_id_idx ON gaiadr3.tmass_psc_xsc_neighbourhood (source_id);

-- [Cruce con catálogos externos] gaiadr3.tycho2tdsc_merge — acceso: TAP Gaia (ADQL)
CREATE TABLE IF NOT EXISTS gaiadr3.tycho2tdsc_merge (
    id text,
    hip integer,
    tyc1 text,
    tyc2 text,
    tyc3 text,
    id_tycho bigint,
    tyc text,
    ra double precision,
    dec double precision,
    ra_deg double precision,
    de_deg double precision,
    ra_mdeg double precision,
    de_mdeg double precision,
    pm_ra real,
    pm_de real,
    ep_ra1990 real,
    ep_de1990 real,
    ep_ra_m real,
    ep_de_m real,
    num smallint,
    e_ra_deg double precision,
    e_de_deg double precision,
    corr double precision,
    e_ra_mdeg double precision,
    e_de_mdeg double precision,
    e_pm_ra real,
    e_pm_de real,
    q_ra_mdeg real,
    q_de_mdeg real,
    q_pm_de real,
    q_pm_ra real,
    pflag text,
    posflg text,
    ccdm text,
    prox smallint,
    bt_mag real,
    vt_mag real,
    e_bt_mag real,
    e_vt_mag real,
    sys_no integer,
    cmp text,
    n_main smallint,
    n_sup smallint,
    magflg text,
    wds text,
    note text,
    hd integer,
    rcmp text,
    pa real,
    sep real,
    e_pa real,
    e_pa_sep smallint,
    e_sep smallint
);
COMMENT ON TABLE gaiadr3.tycho2tdsc_merge IS 'Tycho-2 merged with the TDSC catalog and TDSC supplement. The Tycho Double Star Catalogue, (TDSC, ) contains 98482 components of double and multiple systems processed in the Tycho-2 context. It includes either original Tycho-2 data or results from a dedicated re-processing aimed at binaries. As pointed out by P. Marrese (personal communication), the TDSC star with identifier 29583 is redundant and it was therefore skipped. The TDSC supplement contains data from an additional 4777 components from either Hipparcos or Tycho-1. The Tycho-2 main catalogue contains 2539913 sources, including many binaries, but a minimum separation of 0.8 arcsec was imposed during the catalogue construction. The Tycho-2 supplement-1 contains data for 17588 Hipparcos and Tycho-1 stars, which do not appear in the main catalogue, but only the 4777 stars relevant for TDSC are included here. The Tycho-2 supplement-2 contains an additional 1146 Tycho-1 stars of poor quality. We have merged Tycho-2 (main) with the TDSC main and supplement, keeping the Tycho-2 data model and extending it to include TDSC–specific fields. This is only possible to a certain degree as specified in detail below. In particular, Tycho-2 includes fields for mean position, proper motion etc. for a combination of Tycho-2 and several ground based catalogues. These fields are inherited for TDSC main stars, but were not derived for the TDSC supplement, where we only provide HIP proper motions. For Tycho-2 stars not in TDSC, blank TDSC fields were appended. For Tycho-2 stars in TDSC, the following fields were replaced by the corresponding TDSC fields: - tyc1, tyc2, tyc3; - hip; - ccdm. In addition, if the TDSC contains a new solution: - btMag, eBtMag, vtMag, eVtMag, raDeg, deDeg, epRa1990, epDe1990, eRaDeg, eDeDec; - The mean position flag, pflag, is set to ‘P’ (“photocentre") if resolved and there are Tycho-2 mean positions. Mean position etc. are then repeated for both new components; - The proximity indicator, prox, is set to blank if the Tycho-2 star was resolved in TDSC; - The type-of-solution flag, posflg, set to ‘N’; - For resolved Tycho-2 stars, two records are given. For the few TDSC stars with new solutions, but not in Tycho-2, and for the TDSC supplement stars (Hipparcos or Tycho-1), the Tycho-2 part of the merged record was populated in the following way: - TYC1..3 from TDSC; - pflag set to TDSC pmflg (‘H’ or ‘X’), ‘H’ indicating Hip proper motions; - no mean position and related fields; - proper motions only for Hipparcos stars; - $B_{\rm T}, V_{\rm T}$ photometry from TDSC; - Tycho-1 flag, tyc, is set to posflg, i.e. ‘T’ or ‘H’ although Hipparcos stars may well be in Tycho-1; - Hipparcos, hip, and CCDM, ccdm, identifiers from TDSC; - astrometry from TDSC, but the (ra, dec)-correlation, corr, is set to blank. New TDSC specific fields added after the Tycho-2 part of the record: - sysNo, cmp, nMain, nSup, magflg, wds, note, hd; - rcmp, pa, sep, ePa, ePaSep, eSep.';
COMMENT ON COLUMN gaiadr3.tycho2tdsc_merge.id IS 'Tycho-2 identifier';
COMMENT ON COLUMN gaiadr3.tycho2tdsc_merge.hip IS 'Hipparcos number';
COMMENT ON COLUMN gaiadr3.tycho2tdsc_merge.tyc1 IS 'TYC1 component from TYC or GSC';
COMMENT ON COLUMN gaiadr3.tycho2tdsc_merge.tyc2 IS 'TYC2 component from TYC or GSC';
COMMENT ON COLUMN gaiadr3.tycho2tdsc_merge.tyc3 IS 'TYC3 component from TYC or TDSC';
COMMENT ON COLUMN gaiadr3.tycho2tdsc_merge.id_tycho IS 'Numeric Tycho-2 identifier';
COMMENT ON COLUMN gaiadr3.tycho2tdsc_merge.tyc IS 'Tycho-1 star';
COMMENT ON COLUMN gaiadr3.tycho2tdsc_merge.ra IS 'Observed Tycho-2 Right Ascension, ICRS [deg]';
COMMENT ON COLUMN gaiadr3.tycho2tdsc_merge.dec IS 'Observed Tycho-2 Declination, ICRS [deg]';
COMMENT ON COLUMN gaiadr3.tycho2tdsc_merge.ra_deg IS 'Observed Tycho-2 Right Ascension, ICRS [deg]';
COMMENT ON COLUMN gaiadr3.tycho2tdsc_merge.de_deg IS 'Observed Tycho-2 Declination, ICRS [deg]';
COMMENT ON COLUMN gaiadr3.tycho2tdsc_merge.ra_mdeg IS 'Mean Right Ascension, ICRS, epoch=J2000 [deg]';
COMMENT ON COLUMN gaiadr3.tycho2tdsc_merge.de_mdeg IS 'Mean Declination, ICRS, at epoch=J2000 [deg]';
COMMENT ON COLUMN gaiadr3.tycho2tdsc_merge.pm_ra IS 'Proper motion in RA*cos(dec) [mas/yr]';
COMMENT ON COLUMN gaiadr3.tycho2tdsc_merge.pm_de IS 'Proper motion in Dec [mas/yr]';
COMMENT ON COLUMN gaiadr3.tycho2tdsc_merge.ep_ra1990 IS 'Epoch--1990 of raDeg [yr]';
COMMENT ON COLUMN gaiadr3.tycho2tdsc_merge.ep_de1990 IS 'Epoch--1990 of deDeg [yr]';
COMMENT ON COLUMN gaiadr3.tycho2tdsc_merge.ep_ra_m IS 'Mean epoch of RA. [yr]';
COMMENT ON COLUMN gaiadr3.tycho2tdsc_merge.ep_de_m IS 'Mean epoch of Dec. [yr]';
COMMENT ON COLUMN gaiadr3.tycho2tdsc_merge.num IS 'Number of positions used for forming mean data';
COMMENT ON COLUMN gaiadr3.tycho2tdsc_merge.e_ra_deg IS 'Uncertainty RA*cos(dec), of observed Tycho-2 RA. [mas]';
COMMENT ON COLUMN gaiadr3.tycho2tdsc_merge.e_de_deg IS 'Uncertainty of observed Tycho-2 Dec. [mas]';
COMMENT ON COLUMN gaiadr3.tycho2tdsc_merge.corr IS 'Correlation (RAdeg,DEdeg)';
COMMENT ON COLUMN gaiadr3.tycho2tdsc_merge.e_ra_mdeg IS 'Uncertainty RA*cos(dec),at mean epoch. [mas]';
COMMENT ON COLUMN gaiadr3.tycho2tdsc_merge.e_de_mdeg IS 'Uncertainty of Dec at mean epoch. [mas]';
COMMENT ON COLUMN gaiadr3.tycho2tdsc_merge.e_pm_ra IS 'Uncertainty proper motion in RA*cos(dec). [mas/yr]';
COMMENT ON COLUMN gaiadr3.tycho2tdsc_merge.e_pm_de IS 'Uncertainty of proper motion in Dec. [mas/yr]';
COMMENT ON COLUMN gaiadr3.tycho2tdsc_merge.q_ra_mdeg IS 'Goodness of fit for mean RA';
COMMENT ON COLUMN gaiadr3.tycho2tdsc_merge.q_de_mdeg IS 'Goodness of fit for mean Dec';
COMMENT ON COLUMN gaiadr3.tycho2tdsc_merge.q_pm_de IS 'Goodness of fit for pmDe';
COMMENT ON COLUMN gaiadr3.tycho2tdsc_merge.q_pm_ra IS 'Goodness of fit for pmRa';
COMMENT ON COLUMN gaiadr3.tycho2tdsc_merge.pflag IS 'Mean position flag';
COMMENT ON COLUMN gaiadr3.tycho2tdsc_merge.posflg IS 'Type of Tycho-2 solution';
COMMENT ON COLUMN gaiadr3.tycho2tdsc_merge.ccdm IS 'CCDM component identifier for HIP stars';
COMMENT ON COLUMN gaiadr3.tycho2tdsc_merge.prox IS 'Proximity indicator [mas.100]';
COMMENT ON COLUMN gaiadr3.tycho2tdsc_merge.bt_mag IS 'Tycho-2 BT magnitude [mag]';
COMMENT ON COLUMN gaiadr3.tycho2tdsc_merge.vt_mag IS 'Tycho-2 VT magnitude [mag]';
COMMENT ON COLUMN gaiadr3.tycho2tdsc_merge.e_bt_mag IS 'Uncertainty of BT [mag]';
COMMENT ON COLUMN gaiadr3.tycho2tdsc_merge.e_vt_mag IS 'Uncertainty of VT [mag]';
COMMENT ON COLUMN gaiadr3.tycho2tdsc_merge.sys_no IS 'TDSC identifier for the system';
COMMENT ON COLUMN gaiadr3.tycho2tdsc_merge.cmp IS 'Component designation';
COMMENT ON COLUMN gaiadr3.tycho2tdsc_merge.n_main IS 'Number of components in TDSC main catalogue';
COMMENT ON COLUMN gaiadr3.tycho2tdsc_merge.n_sup IS 'Number of components in the TDSC supplement';
COMMENT ON COLUMN gaiadr3.tycho2tdsc_merge.magflg IS 'TDSC photometry flag';
COMMENT ON COLUMN gaiadr3.tycho2tdsc_merge.wds IS 'WDS identifier for the system';
COMMENT ON COLUMN gaiadr3.tycho2tdsc_merge.note IS 'TDSC notes';
COMMENT ON COLUMN gaiadr3.tycho2tdsc_merge.hd IS 'HD identifier for TDSC entries';
COMMENT ON COLUMN gaiadr3.tycho2tdsc_merge.rcmp IS 'Reference component for position angle and separation';
COMMENT ON COLUMN gaiadr3.tycho2tdsc_merge.pa IS 'Position angle [deg]';
COMMENT ON COLUMN gaiadr3.tycho2tdsc_merge.sep IS 'Separation [arcsec]';
COMMENT ON COLUMN gaiadr3.tycho2tdsc_merge.e_pa IS 'Uncertainty of the position angle [deg]';
COMMENT ON COLUMN gaiadr3.tycho2tdsc_merge.e_pa_sep IS 'Uncertainty of the position angle * separation';
COMMENT ON COLUMN gaiadr3.tycho2tdsc_merge.e_sep IS 'Uncertainty of the separation [mas]';

-- [Cruce con catálogos externos] gaiadr3.tycho2tdsc_merge_best_neighbour — acceso: TAP Gaia (ADQL)
CREATE TABLE IF NOT EXISTS gaiadr3.tycho2tdsc_merge_best_neighbour (
    source_id bigint,
    original_ext_source_id text,
    angular_distance real,
    xm_flag smallint,
    tycho2tdsc_merge_oid integer,
    number_of_neighbours smallint
);
COMMENT ON TABLE gaiadr3.tycho2tdsc_merge_best_neighbour IS '<p>Tycho2TDSCmerge BestNeighbour table lists each matched external catalogue object with its best neighbour in Gaia. The cross-match algorithm is not symmetric and searches Tycho2TDSCmerge sources counterparts in Gaia.<br/> The best neighbour is chosen among good neighbours as the one with the highest value of the figure of merit, which evaluates the ratio between two opposite models/hypotheses: the counterpart candidate is a match or it is found by chance. Good neighbours are nearby objects in Gaia whose position is compatible within position errors with the external catalogue target.<br/> The cross-match algorithm is positional and exploits the full 5 parameters covariance matrix of Gaia astrometric solution when available and the external catalogue positions and position errors. In addition it takes into account the Gaia environment using the local density.<br/> <br/> Please note that the cross-match algorithm is a trade-off between multiple requirements, in particular between completeness and correctness. It is thus not limited to a simple cone search.<br/> <br/> Reference papers:<br/> </p> <p>DR1-DPACP-17<br/> </p> <p>DR2-DPACP-41<br/> </p>';
COMMENT ON COLUMN gaiadr3.tycho2tdsc_merge_best_neighbour.source_id IS 'Unique Gaia source identifier';
COMMENT ON COLUMN gaiadr3.tycho2tdsc_merge_best_neighbour.original_ext_source_id IS 'Original External Catalogue source identifier';
COMMENT ON COLUMN gaiadr3.tycho2tdsc_merge_best_neighbour.angular_distance IS 'Angular Distance between the two sources [arcsec]';
COMMENT ON COLUMN gaiadr3.tycho2tdsc_merge_best_neighbour.xm_flag IS 'Cross-match algorithm flag';
COMMENT ON COLUMN gaiadr3.tycho2tdsc_merge_best_neighbour.tycho2tdsc_merge_oid IS 'External Catalogue source identifier';
COMMENT ON COLUMN gaiadr3.tycho2tdsc_merge_best_neighbour.number_of_neighbours IS 'Number of neighbours in Gaia Catalogue';
CREATE INDEX IF NOT EXISTS gaiadr3_tycho2tdsc_merge_best_neighbour_source_id_idx ON gaiadr3.tycho2tdsc_merge_best_neighbour (source_id);

-- [Cruce con catálogos externos] gaiadr3.tycho2tdsc_merge_neighbourhood — acceso: TAP Gaia (ADQL)
CREATE TABLE IF NOT EXISTS gaiadr3.tycho2tdsc_merge_neighbourhood (
    source_id bigint,
    original_ext_source_id text,
    angular_distance real,
    score double precision,
    xm_flag smallint,
    tycho2tdsc_merge_oid integer
);
COMMENT ON TABLE gaiadr3.tycho2tdsc_merge_neighbourhood IS '<p>Tycho2TDSCmerge Neighbourhood table includes all good neighbours for each matched Tycho2TDSCmerge object. A good neighbour for a given Tycho2TDSCmerge source is a nearby Gaia object whose position is compatible (within position errors) with the Tycho2TDSCmerge target. <br/> The cross-match algorithm is not symmetric and searches Tycho2TDSCmerge sources counterparts in Gaia. The cross-match algorithm is positional and exploits the full 5 parameters covariance matrix of Gaia astrometric solution when available and the external catalogue positions and position errors. In addition it takes into account the Gaia environment using the local density.<br/> <br/> Please note that the cross-match algorithm is a trade-off between multiple requirements, in particular between completeness and correctness. It is thus not limited to a simple cone search.<br/> <br/> Reference papers:<br/> </p> <p>DR1-DPACP-17<br/> </p> <p>DR2-DPACP-41<br/> </p>';
COMMENT ON COLUMN gaiadr3.tycho2tdsc_merge_neighbourhood.source_id IS 'Unique Gaia source identifier';
COMMENT ON COLUMN gaiadr3.tycho2tdsc_merge_neighbourhood.original_ext_source_id IS 'Original External Catalogue source identifier';
COMMENT ON COLUMN gaiadr3.tycho2tdsc_merge_neighbourhood.angular_distance IS 'Angular Distance between the two sources [arcsec]';
COMMENT ON COLUMN gaiadr3.tycho2tdsc_merge_neighbourhood.score IS 'Score of neighbours';
COMMENT ON COLUMN gaiadr3.tycho2tdsc_merge_neighbourhood.xm_flag IS 'Cross-match algorithm flag';
COMMENT ON COLUMN gaiadr3.tycho2tdsc_merge_neighbourhood.tycho2tdsc_merge_oid IS 'External Catalogue source identifier';
CREATE INDEX IF NOT EXISTS gaiadr3_tycho2tdsc_merge_neighbourhood_source_id_idx ON gaiadr3.tycho2tdsc_merge_neighbourhood (source_id);

-- [Cruce con catálogos externos] gaiadr3.urat1_best_neighbour — acceso: TAP Gaia (ADQL)
CREATE TABLE IF NOT EXISTS gaiadr3.urat1_best_neighbour (
    source_id bigint,
    original_ext_source_id text,
    angular_distance real,
    xm_flag smallint,
    urat1_oid integer,
    number_of_neighbours smallint,
    number_of_mates smallint
);
COMMENT ON TABLE gaiadr3.urat1_best_neighbour IS '<p>URAT-1 BestNeighbour table lists each matched Gaia object with its best neighbour in the external catalogue. The cross-match algorithm is not symmetric and searches Gaia sources counterparts in URAT-1.<br/> The best neighbour is chosen among good neighbours as the one with the highest value of the figure of merit, which evaluates the ratio between two opposite models/hypotheses: the counterpart candidate is a match or it is found by chance. Good neighbours are nearby objects in the external catalogue whose position is compatible within position errors with the Gaia target.<br/> The cross-match algorithm is positional and exploits the full 5 parameters covariance matrix of Gaia astrometric solution when available and the external catalogue positions and position errors. In addition it takes into account the external catalogue environment using the local density.<br/> <br/> Please note that the cross-match algorithm is a trade-off between multiple requirements, in particular between completeness and correctness. It is thus not limited to a simple cone search.<br/> <br/> Reference papers:<br/> </p> <p>DR1-DPACP-17<br/> </p> <p>DR2-DPACP-41<br/> </p>';
COMMENT ON COLUMN gaiadr3.urat1_best_neighbour.source_id IS 'Unique Gaia source identifier';
COMMENT ON COLUMN gaiadr3.urat1_best_neighbour.original_ext_source_id IS 'Original External Catalogue source identifier';
COMMENT ON COLUMN gaiadr3.urat1_best_neighbour.angular_distance IS 'Angular Distance between the two sources [arcsec]';
COMMENT ON COLUMN gaiadr3.urat1_best_neighbour.xm_flag IS 'Cross-match algorithm flag';
COMMENT ON COLUMN gaiadr3.urat1_best_neighbour.urat1_oid IS 'External Catalogue source identifier';
COMMENT ON COLUMN gaiadr3.urat1_best_neighbour.number_of_neighbours IS 'Number of neighbours in External Catalogue';
COMMENT ON COLUMN gaiadr3.urat1_best_neighbour.number_of_mates IS 'Number of mates in Gaia Catalogue';
CREATE INDEX IF NOT EXISTS gaiadr3_urat1_best_neighbour_source_id_idx ON gaiadr3.urat1_best_neighbour (source_id);

-- [Cruce con catálogos externos] gaiadr3.urat1_neighbourhood — acceso: TAP Gaia (ADQL)
CREATE TABLE IF NOT EXISTS gaiadr3.urat1_neighbourhood (
    source_id bigint,
    original_ext_source_id text,
    angular_distance real,
    score double precision,
    xm_flag smallint,
    urat1_oid integer
);
COMMENT ON TABLE gaiadr3.urat1_neighbourhood IS '<p>URAT-1 Neighbourhood table includes all good neighbours for each matched Gaia object. A good neighbour for a given Gaia source is a nearby object in the external catalogue whose position is compatible (within position errors) with the Gaia target. <br/> The cross-match algorithm is not symmetric and searches Gaia sources counterparts in URAT-1. The cross-match algorithm is positional and exploits the full 5 parameters covariance matrix of Gaia astrometric solution when available and the external catalogue positions and position errors. In addition it takes into account the external catalogue environment using the local density.<br/> <br/> Please note that the cross-match algorithm is a trade-off between multiple requirements, in particular between completeness and correctness. It is thus not limited to a simple cone search.<br/> <br/> Reference papers:<br/> </p> <p>DR1-DPACP-17<br/> </p> <p>DR2-DPACP-41<br/> </p>';
COMMENT ON COLUMN gaiadr3.urat1_neighbourhood.source_id IS 'Unique Gaia source identifier';
COMMENT ON COLUMN gaiadr3.urat1_neighbourhood.original_ext_source_id IS 'Original External Catalogue source identifier';
COMMENT ON COLUMN gaiadr3.urat1_neighbourhood.angular_distance IS 'Angular Distance between the two sources [arcsec]';
COMMENT ON COLUMN gaiadr3.urat1_neighbourhood.score IS 'Score of neighbours';
COMMENT ON COLUMN gaiadr3.urat1_neighbourhood.xm_flag IS 'Cross-match algorithm flag';
COMMENT ON COLUMN gaiadr3.urat1_neighbourhood.urat1_oid IS 'External Catalogue source identifier';
CREATE INDEX IF NOT EXISTS gaiadr3_urat1_neighbourhood_source_id_idx ON gaiadr3.urat1_neighbourhood (source_id);

-- [Extragaláctico] gaiadr3.galaxy_candidates — acceso: TAP Gaia (ADQL)
CREATE TABLE IF NOT EXISTS gaiadr3.galaxy_candidates (
    solution_id bigint,
    source_id bigint,
    vari_best_class_name text,
    vari_best_class_score real,
    classprob_dsc_combmod_galaxy real,
    classprob_dsc_combmod_quasar real,
    classlabel_dsc text,
    classlabel_dsc_joint text,
    classlabel_oa text,
    redshift_ugc real,
    redshift_ugc_lower real,
    redshift_ugc_upper real,
    n_transits integer,
    posangle_sersic double precision,
    posangle_sersic_error double precision,
    intensity_sersic double precision,
    intensity_sersic_error double precision,
    radius_sersic double precision,
    radius_sersic_error double precision,
    ellipticity_sersic double precision,
    ellipticity_sersic_error double precision,
    n_sersic real,
    n_sersic_error real,
    l2_sersic double precision,
    morph_params_corr_vec_sersic double precision[],
    flags_sersic smallint,
    posangle_de_vaucouleurs double precision,
    posangle_de_vaucouleurs_error double precision,
    intensity_de_vaucouleurs double precision,
    intensity_de_vaucouleurs_error double precision,
    radius_de_vaucouleurs double precision,
    radius_de_vaucouleurs_error double precision,
    ellipticity_de_vaucouleurs double precision,
    ellipticity_de_vaucouleurs_error double precision,
    l2_de_vaucouleurs double precision,
    morph_params_corr_vec_de_vaucouleurs double precision[],
    flags_de_vaucouleurs smallint,
    source_selection_flags integer
);
COMMENT ON TABLE gaiadr3.galaxy_candidates IS 'This table contains parameters derived from various modules dedicated to the classification and characterisation of sources considered as galaxy candidates. This table has been constructed with the intention to be complete rather than pure and, as such, it will contain a large fraction of non-genuine extragalactic sources. Purer samples can be drawn using dedicated flags or queries. Please refer to Chapter~\ref{chap:cu3qso} of the on-line documentation for details about how this table was built, its content, and for recommendations regarding its exploitation.';
COMMENT ON COLUMN gaiadr3.galaxy_candidates.solution_id IS 'Solution Identifier';
COMMENT ON COLUMN gaiadr3.galaxy_candidates.source_id IS 'Unique source identifier (unique within a particular Data Release)';
COMMENT ON COLUMN gaiadr3.galaxy_candidates.vari_best_class_name IS 'Name of best class, see table VariClassifierClassDefinition for details of the class';
COMMENT ON COLUMN gaiadr3.galaxy_candidates.vari_best_class_score IS 'Score of the best class';
COMMENT ON COLUMN gaiadr3.galaxy_candidates.classprob_dsc_combmod_galaxy IS 'Probability from DSC-Combmod of being a galaxy (data used: BP/RP spectrum, photometry, astrometry)';
COMMENT ON COLUMN gaiadr3.galaxy_candidates.classprob_dsc_combmod_quasar IS 'Probability from DSC-Combmod of being a quasar (data used: BP/RP spectrum, photometry, astrometry)';
COMMENT ON COLUMN gaiadr3.galaxy_candidates.classlabel_dsc IS 'Class assigned by DSC based on the probability from its Combmod classifier';
COMMENT ON COLUMN gaiadr3.galaxy_candidates.classlabel_dsc_joint IS 'Class assigned by DSC based on the probability from its Specmod and Allosmod classifiers';
COMMENT ON COLUMN gaiadr3.galaxy_candidates.classlabel_oa IS 'Class assigned by OA the neuron that represents the source';
COMMENT ON COLUMN gaiadr3.galaxy_candidates.redshift_ugc IS 'Redshift from UGC';
COMMENT ON COLUMN gaiadr3.galaxy_candidates.redshift_ugc_lower IS 'Redshift prediction lower limit from UGC';
COMMENT ON COLUMN gaiadr3.galaxy_candidates.redshift_ugc_upper IS 'Redshift prediction upper limit from UGC';
COMMENT ON COLUMN gaiadr3.galaxy_candidates.n_transits IS 'Number of transits used for the morphological analysis';
COMMENT ON COLUMN gaiadr3.galaxy_candidates.posangle_sersic IS 'Fitted position angle of the source for the Sersic Profile [deg]';
COMMENT ON COLUMN gaiadr3.galaxy_candidates.posangle_sersic_error IS 'Error on the fitted position angle of the source for the Sersic Profile [deg]';
COMMENT ON COLUMN gaiadr3.galaxy_candidates.intensity_sersic IS 'Fitted intensity of the source for the Sersic Profile [''electron''.s**-1]';
COMMENT ON COLUMN gaiadr3.galaxy_candidates.intensity_sersic_error IS 'Error on the fitted intensity of the source at effective radius radiusSersic [''electron''.s**-1]';
COMMENT ON COLUMN gaiadr3.galaxy_candidates.radius_sersic IS 'Fitted effective radius of the source for the Sersic Profile [mas]';
COMMENT ON COLUMN gaiadr3.galaxy_candidates.radius_sersic_error IS 'Error on the fitted effective radius of the source for the Sersic Profile [mas]';
COMMENT ON COLUMN gaiadr3.galaxy_candidates.ellipticity_sersic IS 'Fitted ellipticity of source for the Sersic Profile';
COMMENT ON COLUMN gaiadr3.galaxy_candidates.ellipticity_sersic_error IS 'Error on the fitted ellipticity of the source for the Sersic Profile';
COMMENT ON COLUMN gaiadr3.galaxy_candidates.n_sersic IS 'Fitted Sersic Index for Sersic Profile';
COMMENT ON COLUMN gaiadr3.galaxy_candidates.n_sersic_error IS 'Error on the fitted Sersic Index for Sersic Profile';
COMMENT ON COLUMN gaiadr3.galaxy_candidates.l2_sersic IS 'L2 norm for the Sersic Profile';
COMMENT ON COLUMN gaiadr3.galaxy_candidates.morph_params_corr_vec_sersic IS 'Vector form of the upper triangle of the correlation matrix for the fitted parameters for the Sersic Profile';
COMMENT ON COLUMN gaiadr3.galaxy_candidates.flags_sersic IS 'Flag indicative of processing or scientific quality for the morphological parameters fitting for the Sersic Profile';
COMMENT ON COLUMN gaiadr3.galaxy_candidates.posangle_de_vaucouleurs IS 'Fitted position angle of the source for the de Vaucouleurs Profile [deg]';
COMMENT ON COLUMN gaiadr3.galaxy_candidates.posangle_de_vaucouleurs_error IS 'Error on the fitted position angle of the source for the de Vaucouleurs Profile [deg]';
COMMENT ON COLUMN gaiadr3.galaxy_candidates.intensity_de_vaucouleurs IS 'Fitted intensity of the source for the de Vaucouleurs Profile [''electron''.s**-1]';
COMMENT ON COLUMN gaiadr3.galaxy_candidates.intensity_de_vaucouleurs_error IS 'Error on the fitted intensity of the bulge for the de Vaucouleurs Profile [''electron''.s**-1]';
COMMENT ON COLUMN gaiadr3.galaxy_candidates.radius_de_vaucouleurs IS 'Fitted effective radius of the source for de Vaucouleurs Profile [mas]';
COMMENT ON COLUMN gaiadr3.galaxy_candidates.radius_de_vaucouleurs_error IS 'Error on the fitted effective radius of the source for the de Vaucouleurs Profile [mas]';
COMMENT ON COLUMN gaiadr3.galaxy_candidates.ellipticity_de_vaucouleurs IS 'Fitted ellipticity of source for the de Vaucouleurs Profile';
COMMENT ON COLUMN gaiadr3.galaxy_candidates.ellipticity_de_vaucouleurs_error IS 'Error on the fitted ellipticity of the source for the de Vaucouleurs Profile';
COMMENT ON COLUMN gaiadr3.galaxy_candidates.l2_de_vaucouleurs IS 'L2 norm for the de Vaucouleurs Profile';
COMMENT ON COLUMN gaiadr3.galaxy_candidates.morph_params_corr_vec_de_vaucouleurs IS 'Vector form of the upper triangle of the correlation matrix for the fitted parameters for the de Vaucouleurs Profile';
COMMENT ON COLUMN gaiadr3.galaxy_candidates.flags_de_vaucouleurs IS 'Flag indicative of processing or scientific quality for the morphological parameters fitting for the de Vaucouleurs Profile';
COMMENT ON COLUMN gaiadr3.galaxy_candidates.source_selection_flags IS 'Bit indicative of whether the input data from a given module met the source list eligibility criteria for the source of interest';
CREATE INDEX IF NOT EXISTS gaiadr3_galaxy_candidates_source_id_idx ON gaiadr3.galaxy_candidates (source_id);

-- [Extragaláctico] gaiadr3.galaxy_catalogue_name — acceso: TAP Gaia (ADQL)
CREATE TABLE IF NOT EXISTS gaiadr3.galaxy_catalogue_name (
    solution_id bigint,
    source_id bigint,
    catalogue_id smallint
);
COMMENT ON TABLE gaiadr3.galaxy_catalogue_name IS 'This table provides the list of input catalogues that have been used to select any given source for which morphological analysis parameters are provided in table {\tt GalaxyCandidates}. Each source may have been cross-matched to more than one catalogue and therefore can have several entries in the table. For DR3, the catalogues considered for this selection are mostly external, although sources identified by DPAC based on the classification performed by other processing have also been included here. Each catalogue is assigned a \texttt{catalogueId}. For DR3 the only input list corresponds to that published in~\cite{2022Krone-Martins}. Further details on these catalogues are given in the chapter on extended object processing (Section~\ref{sec:cu4eo_list}).';
COMMENT ON COLUMN gaiadr3.galaxy_catalogue_name.solution_id IS 'Solution Identifier';
COMMENT ON COLUMN gaiadr3.galaxy_catalogue_name.source_id IS 'Unique source identifier (unique within a particular Data Release)';
COMMENT ON COLUMN gaiadr3.galaxy_catalogue_name.catalogue_id IS 'The unique identifier for the catalogue(s) used to select the sources in the morphological analysis';
CREATE INDEX IF NOT EXISTS gaiadr3_galaxy_catalogue_name_source_id_idx ON gaiadr3.galaxy_catalogue_name (source_id);

-- [Extragaláctico] gaiadr3.qso_candidates — acceso: TAP Gaia (ADQL)
CREATE TABLE IF NOT EXISTS gaiadr3.qso_candidates (
    solution_id bigint,
    source_id bigint,
    astrometric_selection_flag boolean,
    gaia_crf_source boolean,
    vari_best_class_name text,
    vari_best_class_score real,
    fractional_variability_g real,
    structure_function_index real,
    structure_function_index_scatter double precision,
    qso_variability real,
    non_qso_variability real,
    vari_agn_membership_score double precision,
    classprob_dsc_combmod_quasar real,
    classprob_dsc_combmod_galaxy real,
    classlabel_dsc text,
    classlabel_dsc_joint text,
    classlabel_oa text,
    redshift_qsoc real,
    redshift_qsoc_lower real,
    redshift_qsoc_upper real,
    ccfratio_qsoc real,
    zscore_qsoc real,
    flags_qsoc bigint,
    n_transits integer,
    intensity_quasar double precision,
    intensity_quasar_error double precision,
    intensity_hostgalaxy double precision,
    intensity_hostgalaxy_error double precision,
    radius_hostgalaxy double precision,
    radius_hostgalaxy_error double precision,
    sersic_index real,
    sersic_index_error real,
    ellipticity_hostgalaxy double precision,
    ellipticity_hostgalaxy_error double precision,
    posangle_hostgalaxy double precision,
    posangle_hostgalaxy_error double precision,
    host_galaxy_detected boolean,
    l2_norm double precision,
    morph_params_corr_vec double precision[],
    host_galaxy_flag smallint,
    source_selection_flags integer
);
COMMENT ON TABLE gaiadr3.qso_candidates IS 'This table contains parameters derived from various modules dedicated to the classification and characterisation of sources considered as QSO candidates. Together with those, the QSOs used to define the Gaia-CRF3 are also listed in this table. This table has been constructed with the intention to be complete rather than pure and, as such, it will contain a large fraction of non-genuine extragalactic sources. Purer samples can be drawn using dedicated flags or queries. Please refer to Chapter~\ref{chap:cu3qso} of the on-line documentation for details about how this table was built, its content, and for recommendations regarding its exploitation.';
COMMENT ON COLUMN gaiadr3.qso_candidates.solution_id IS 'Solution Identifier';
COMMENT ON COLUMN gaiadr3.qso_candidates.source_id IS 'Unique source identifier (unique within a particular Data Release)';
COMMENT ON COLUMN gaiadr3.qso_candidates.astrometric_selection_flag IS 'Flag indicating if the source is part of the astrometric selection';
COMMENT ON COLUMN gaiadr3.qso_candidates.gaia_crf_source IS 'Flag indicative of whether the source was used define the Gaia-CRF3';
COMMENT ON COLUMN gaiadr3.qso_candidates.vari_best_class_name IS 'Name of best class, see table VariClassifierClassDefinition for details of the class';
COMMENT ON COLUMN gaiadr3.qso_candidates.vari_best_class_score IS 'Score of the best class';
COMMENT ON COLUMN gaiadr3.qso_candidates.fractional_variability_g IS 'Fractional variability in the G band';
COMMENT ON COLUMN gaiadr3.qso_candidates.structure_function_index IS 'Index of the first-order structure function in the G band';
COMMENT ON COLUMN gaiadr3.qso_candidates.structure_function_index_scatter IS 'Standard deviation of the index of the structure function';
COMMENT ON COLUMN gaiadr3.qso_candidates.qso_variability IS 'Quasar variability metric in the G band';
COMMENT ON COLUMN gaiadr3.qso_candidates.non_qso_variability IS 'Non-quasar variability metric in the G band';
COMMENT ON COLUMN gaiadr3.qso_candidates.vari_agn_membership_score IS 'Membership score (0=lowest,1=highest) of source to be of AGN type';
COMMENT ON COLUMN gaiadr3.qso_candidates.classprob_dsc_combmod_quasar IS 'Probability from DSC-Combmod of being a quasar (data used: BP/RP spectrum, photometry, astrometry)';
COMMENT ON COLUMN gaiadr3.qso_candidates.classprob_dsc_combmod_galaxy IS 'Probability from DSC-Combmod of being a galaxy (data used: BP/RP spectrum, photometry, astrometry)';
COMMENT ON COLUMN gaiadr3.qso_candidates.classlabel_dsc IS 'Class assigned by DSC based on the probability from its Combmod classifier';
COMMENT ON COLUMN gaiadr3.qso_candidates.classlabel_dsc_joint IS 'Class assigned by DSC based on the probability from its Specmod and Allosmod classifiers';
COMMENT ON COLUMN gaiadr3.qso_candidates.classlabel_oa IS 'Class assigned by OA the neuron that represents the source';
COMMENT ON COLUMN gaiadr3.qso_candidates.redshift_qsoc IS 'Redshift from QSOC';
COMMENT ON COLUMN gaiadr3.qso_candidates.redshift_qsoc_lower IS 'Redshift lower confidence level from QSOC';
COMMENT ON COLUMN gaiadr3.qso_candidates.redshift_qsoc_upper IS 'Redshift upper confidence level from QSOC';
COMMENT ON COLUMN gaiadr3.qso_candidates.ccfratio_qsoc IS 'Value of the cross-correlation function used to derive the redshift from QSOC, relative to the maximum value';
COMMENT ON COLUMN gaiadr3.qso_candidates.zscore_qsoc IS 'Redshift zscore from QSOC';
COMMENT ON COLUMN gaiadr3.qso_candidates.flags_qsoc IS 'Processing flags for the analysis based on BP/RP Spectra from QSOC';
COMMENT ON COLUMN gaiadr3.qso_candidates.n_transits IS 'Number of transits used for the morphological analysis';
COMMENT ON COLUMN gaiadr3.qso_candidates.intensity_quasar IS 'Fitted intensity of the quasar at its center [''electron''.s**-1]';
COMMENT ON COLUMN gaiadr3.qso_candidates.intensity_quasar_error IS 'Error on the fitted intensity of the quasar at its center [''electron''.s**-1]';
COMMENT ON COLUMN gaiadr3.qso_candidates.intensity_hostgalaxy IS 'Fitted intensity of the host galaxy at the effective radius [''electron''.s**-1]';
COMMENT ON COLUMN gaiadr3.qso_candidates.intensity_hostgalaxy_error IS 'Error on the fitted intensity of the host galaxy at effective radius [''electron''.s**-1]';
COMMENT ON COLUMN gaiadr3.qso_candidates.radius_hostgalaxy IS 'Fitted effective radius of the host galaxy [mas]';
COMMENT ON COLUMN gaiadr3.qso_candidates.radius_hostgalaxy_error IS 'Error on the fitted effective radius of the host galaxy [mas]';
COMMENT ON COLUMN gaiadr3.qso_candidates.sersic_index IS 'Fitted sersic Index';
COMMENT ON COLUMN gaiadr3.qso_candidates.sersic_index_error IS 'Error on the fitted sersic Index';
COMMENT ON COLUMN gaiadr3.qso_candidates.ellipticity_hostgalaxy IS 'Fitted ellipticity of the host galaxy';
COMMENT ON COLUMN gaiadr3.qso_candidates.ellipticity_hostgalaxy_error IS 'Error on the fitted ellipticity of the host galaxy';
COMMENT ON COLUMN gaiadr3.qso_candidates.posangle_hostgalaxy IS 'Fitted position angle of the host galaxy [deg]';
COMMENT ON COLUMN gaiadr3.qso_candidates.posangle_hostgalaxy_error IS 'Error on the fitted position angle of the host galaxy [deg]';
COMMENT ON COLUMN gaiadr3.qso_candidates.host_galaxy_detected IS 'Flag indicating whether a host galaxy has been detected';
COMMENT ON COLUMN gaiadr3.qso_candidates.l2_norm IS 'L2 norm for the fitted Sersic profile';
COMMENT ON COLUMN gaiadr3.qso_candidates.morph_params_corr_vec IS 'Vector form of the upper triangle of the correlation matrix for the fitted morphological parameters';
COMMENT ON COLUMN gaiadr3.qso_candidates.host_galaxy_flag IS 'Flag indicative of processing or scientific quality for the morphological parameters fitting';
COMMENT ON COLUMN gaiadr3.qso_candidates.source_selection_flags IS 'Bit indicative of whether the input data from a given module met the source list eligibility criteria for the source of interest';
CREATE INDEX IF NOT EXISTS gaiadr3_qso_candidates_source_id_idx ON gaiadr3.qso_candidates (source_id);

-- [Extragaláctico] gaiadr3.qso_catalogue_name — acceso: TAP Gaia (ADQL)
CREATE TABLE IF NOT EXISTS gaiadr3.qso_catalogue_name (
    solution_id bigint,
    source_id bigint,
    catalogue_id smallint
);
COMMENT ON TABLE gaiadr3.qso_catalogue_name IS 'This table provides the list of input catalogues that have been used to select any given source for which morphological analysis parameters are provided in table \texttt{QsoCandidates}. Each source may have been cross-matched to more than one catalogue and therefore can have several entries in the table. For DR3, the catalogues considered for this selection are mostly external, although sources identified by DPAC based on the classification performed by other processing have also been included here. Each catalogue is assigned a \texttt{catalogueId}. For DR3 the following applies: \begin{itemize} \item 1: CU7 GaiaVariQso2018 \item 2: ICRF2 \item 3: SDSS-DR12Q \item 4: LQAC3 \item 5: Half Million Quasars \item 6: Secrest+2015 \item 7: Assef+2018\_R90 \end{itemize} Further details on these catalogues are given in the chapter on extended object processing (\secref{sec:cu4eo_list}).';
COMMENT ON COLUMN gaiadr3.qso_catalogue_name.solution_id IS 'Solution Identifier';
COMMENT ON COLUMN gaiadr3.qso_catalogue_name.source_id IS 'Unique source identifier (unique within a particular Data Release)';
COMMENT ON COLUMN gaiadr3.qso_catalogue_name.catalogue_id IS 'The unique identifier for the catalogue(s) used to select the sources in the morphological analysis';
CREATE INDEX IF NOT EXISTS gaiadr3_qso_catalogue_name_source_id_idx ON gaiadr3.qso_catalogue_name (source_id);

-- [Estrellas no simples (binarias)] gaiadr3.nss_acceleration_astro — acceso: TAP Gaia (ADQL)
CREATE TABLE IF NOT EXISTS gaiadr3.nss_acceleration_astro (
    solution_id bigint,
    source_id bigint,
    nss_solution_type text,
    ra double precision,
    ra_error real,
    dec double precision,
    dec_error real,
    parallax double precision,
    parallax_error real,
    pmra double precision,
    pmra_error real,
    pmdec double precision,
    pmdec_error real,
    accel_ra double precision,
    accel_ra_error real,
    accel_dec double precision,
    accel_dec_error real,
    deriv_accel_ra double precision,
    deriv_accel_ra_error real,
    deriv_accel_dec double precision,
    deriv_accel_dec_error real,
    astrometric_n_obs_al integer,
    astrometric_n_good_obs_al integer,
    bit_index bigint,
    corr_vec real[],
    obj_func real,
    goodness_of_fit real,
    significance real,
    flags bigint
);
COMMENT ON TABLE gaiadr3.nss_acceleration_astro IS 'This table contains non-single-star astrometric models for sources having a non-linear proper motion which is compatible with an acceleration solution. Several possible models are hosted within the same table and they are indicated by the field \texttt{nssSolutionType}. The description of this latter lists all possible solution types considered for this release. Only a selection of parameters hosted in this table are provided here, depending on the solution. The details of those is given in the description of field \texttt{bitIndex}, which can also be used to extract the relevant elements of the correlation vector \texttt{corrVec}. Details about the formalism used to derive the parameters in this table are given in the on-line documentation, see Chapter~\ref{chap:cu4nss}.';
COMMENT ON COLUMN gaiadr3.nss_acceleration_astro.solution_id IS 'Solution Identifier';
COMMENT ON COLUMN gaiadr3.nss_acceleration_astro.source_id IS 'Source Identifier';
COMMENT ON COLUMN gaiadr3.nss_acceleration_astro.nss_solution_type IS 'NSS model adopted';
COMMENT ON COLUMN gaiadr3.nss_acceleration_astro.ra IS 'Right ascension [deg]';
COMMENT ON COLUMN gaiadr3.nss_acceleration_astro.ra_error IS 'Standard error of right ascension [mas]';
COMMENT ON COLUMN gaiadr3.nss_acceleration_astro.dec IS 'Declination [deg]';
COMMENT ON COLUMN gaiadr3.nss_acceleration_astro.dec_error IS 'Standard error of declination [mas]';
COMMENT ON COLUMN gaiadr3.nss_acceleration_astro.parallax IS 'Parallax [mas]';
COMMENT ON COLUMN gaiadr3.nss_acceleration_astro.parallax_error IS 'Standard error of parallax [mas]';
COMMENT ON COLUMN gaiadr3.nss_acceleration_astro.pmra IS 'Proper motion in right ascension direction [mas.yr**-1]';
COMMENT ON COLUMN gaiadr3.nss_acceleration_astro.pmra_error IS 'Standard error of proper motion in right ascension direction [mas.yr**-1]';
COMMENT ON COLUMN gaiadr3.nss_acceleration_astro.pmdec IS 'Proper motion in declination direction [mas.yr**-1]';
COMMENT ON COLUMN gaiadr3.nss_acceleration_astro.pmdec_error IS 'Standard error of proper motion in declination direction [mas.yr**-1]';
COMMENT ON COLUMN gaiadr3.nss_acceleration_astro.accel_ra IS 'Acceleration in RA [mas.yr**-2]';
COMMENT ON COLUMN gaiadr3.nss_acceleration_astro.accel_ra_error IS 'Standard error of Acceleration in RA [mas.yr**-2]';
COMMENT ON COLUMN gaiadr3.nss_acceleration_astro.accel_dec IS 'Acceleration in DEC [mas.yr**-2]';
COMMENT ON COLUMN gaiadr3.nss_acceleration_astro.accel_dec_error IS 'Standard error of Acceleration in DEC [mas.yr**-2]';
COMMENT ON COLUMN gaiadr3.nss_acceleration_astro.deriv_accel_ra IS 'Time derivative of the accel. in RA [mas.yr**-3]';
COMMENT ON COLUMN gaiadr3.nss_acceleration_astro.deriv_accel_ra_error IS 'Standard error of Time derivative of the acceleration in RA [mas.yr**-3]';
COMMENT ON COLUMN gaiadr3.nss_acceleration_astro.deriv_accel_dec IS 'Time derivative of the accel. in DEC [mas.yr**-3]';
COMMENT ON COLUMN gaiadr3.nss_acceleration_astro.deriv_accel_dec_error IS 'Standard error of Time derivative of the acceleration in DEC [mas.yr**-3]';
COMMENT ON COLUMN gaiadr3.nss_acceleration_astro.astrometric_n_obs_al IS 'Total astrometric CCD observations in AL considered';
COMMENT ON COLUMN gaiadr3.nss_acceleration_astro.astrometric_n_good_obs_al IS 'Total astrometric CCD observations in AL actually used';
COMMENT ON COLUMN gaiadr3.nss_acceleration_astro.bit_index IS 'Boolean mask for the fields above in the corrVec matrix';
COMMENT ON COLUMN gaiadr3.nss_acceleration_astro.corr_vec IS 'Vector form of the upper triangle of the correlation matrix';
COMMENT ON COLUMN gaiadr3.nss_acceleration_astro.obj_func IS 'Value of the objective function at the solution';
COMMENT ON COLUMN gaiadr3.nss_acceleration_astro.goodness_of_fit IS 'Goodness of fit in the Hipparcos sense';
COMMENT ON COLUMN gaiadr3.nss_acceleration_astro.significance IS 'The significance of the solution (i.e. how worth keeping a model is)';
COMMENT ON COLUMN gaiadr3.nss_acceleration_astro.flags IS 'Quality flag for the achieved NSS solution';
CREATE INDEX IF NOT EXISTS gaiadr3_nss_acceleration_astro_source_id_idx ON gaiadr3.nss_acceleration_astro (source_id);

-- [Estrellas no simples (binarias)] gaiadr3.nss_non_linear_spectro — acceso: TAP Gaia (ADQL)
CREATE TABLE IF NOT EXISTS gaiadr3.nss_non_linear_spectro (
    solution_id bigint,
    source_id bigint,
    nss_solution_type text,
    mean_velocity double precision,
    mean_velocity_error real,
    first_deriv_velocity double precision,
    first_deriv_velocity_error real,
    second_deriv_velocity double precision,
    second_deriv_velocity_error real,
    rv_n_obs_primary integer,
    rv_n_good_obs_primary integer,
    bit_index bigint,
    corr_vec real[],
    obj_func real,
    goodness_of_fit real,
    flags bigint
);
COMMENT ON TABLE gaiadr3.nss_non_linear_spectro IS 'This table contains non-single-star orbital models for spectroscopic binaries compatible with a trend. Several possible models are hosted within the same table and they are indicated by the field \texttt{nssSolutionType}. The description of this latter lists all possible solution types considered for this release. Only a selection of parameters hosted in this table are provided here, depending on the solution. The details of those is given in the description of field \texttt{bitIndex}, which can also be used to extract the relevant elements of the correlation vector \texttt{corrVec}. Details about the formalism used to derive the parameters in this table are given in the on-line documentation, see Chapter~\ref{chap:cu4nss}.';
COMMENT ON COLUMN gaiadr3.nss_non_linear_spectro.solution_id IS 'Solution Identifier';
COMMENT ON COLUMN gaiadr3.nss_non_linear_spectro.source_id IS 'Source Identifier';
COMMENT ON COLUMN gaiadr3.nss_non_linear_spectro.nss_solution_type IS 'NSS model adopted';
COMMENT ON COLUMN gaiadr3.nss_non_linear_spectro.mean_velocity IS 'Mean velocity [km.s**-1]';
COMMENT ON COLUMN gaiadr3.nss_non_linear_spectro.mean_velocity_error IS 'Standard error of Mean velocity [km.s**-1]';
COMMENT ON COLUMN gaiadr3.nss_non_linear_spectro.first_deriv_velocity IS 'First order derivative of the velocity [km.s**-1.d**-1]';
COMMENT ON COLUMN gaiadr3.nss_non_linear_spectro.first_deriv_velocity_error IS 'Standard error of First order derivative of the velocity [km.s**-1.d**-1]';
COMMENT ON COLUMN gaiadr3.nss_non_linear_spectro.second_deriv_velocity IS 'Second order derivative of the velocity [km.s**-1.d**-2]';
COMMENT ON COLUMN gaiadr3.nss_non_linear_spectro.second_deriv_velocity_error IS 'Standard error of Second order derivative of the velocity [km.s**-1.d**-2]';
COMMENT ON COLUMN gaiadr3.nss_non_linear_spectro.rv_n_obs_primary IS 'Total number of radial velocities considered for the primary';
COMMENT ON COLUMN gaiadr3.nss_non_linear_spectro.rv_n_good_obs_primary IS 'Total number of radial velocities actually used for the primary';
COMMENT ON COLUMN gaiadr3.nss_non_linear_spectro.bit_index IS 'Boolean mask for the fields above in the corrVec matrix';
COMMENT ON COLUMN gaiadr3.nss_non_linear_spectro.corr_vec IS 'Vector form of the upper triangle of the correlation matrix';
COMMENT ON COLUMN gaiadr3.nss_non_linear_spectro.obj_func IS 'Value of the objective function at the solution';
COMMENT ON COLUMN gaiadr3.nss_non_linear_spectro.goodness_of_fit IS 'Goodness of fit in the Hipparcos sense';
COMMENT ON COLUMN gaiadr3.nss_non_linear_spectro.flags IS 'Quality flag for the achieved NSS solution';
CREATE INDEX IF NOT EXISTS gaiadr3_nss_non_linear_spectro_source_id_idx ON gaiadr3.nss_non_linear_spectro (source_id);

-- [Estrellas no simples (binarias)] gaiadr3.nss_two_body_orbit — acceso: TAP Gaia (ADQL)
CREATE TABLE IF NOT EXISTS gaiadr3.nss_two_body_orbit (
    solution_id bigint,
    source_id bigint,
    nss_solution_type text,
    ra double precision,
    ra_error real,
    dec double precision,
    dec_error real,
    parallax double precision,
    parallax_error real,
    pmra double precision,
    pmra_error real,
    pmdec double precision,
    pmdec_error real,
    a_thiele_innes double precision,
    a_thiele_innes_error real,
    b_thiele_innes double precision,
    b_thiele_innes_error real,
    f_thiele_innes double precision,
    f_thiele_innes_error real,
    g_thiele_innes double precision,
    g_thiele_innes_error real,
    c_thiele_innes double precision,
    c_thiele_innes_error real,
    h_thiele_innes double precision,
    h_thiele_innes_error real,
    period double precision,
    period_error real,
    t_periastron double precision,
    t_periastron_error real,
    eccentricity double precision,
    eccentricity_error real,
    center_of_mass_velocity double precision,
    center_of_mass_velocity_error real,
    semi_amplitude_primary double precision,
    semi_amplitude_primary_error real,
    semi_amplitude_secondary double precision,
    semi_amplitude_secondary_error real,
    mass_ratio double precision,
    mass_ratio_error real,
    fill_factor_primary double precision,
    fill_factor_primary_error real,
    fill_factor_secondary double precision,
    fill_factor_secondary_error real,
    inclination double precision,
    inclination_error real,
    arg_periastron double precision,
    arg_periastron_error real,
    temperature_ratio double precision,
    temperature_ratio_error double precision,
    temperature_ratio_definition smallint,
    astrometric_n_obs_al integer,
    astrometric_n_good_obs_al integer,
    rv_n_obs_primary integer,
    rv_n_good_obs_primary integer,
    rv_n_obs_secondary integer,
    rv_n_good_obs_secondary integer,
    phot_g_n_obs integer,
    phot_g_n_good_obs integer,
    bit_index bigint,
    corr_vec real[],
    obj_func real,
    goodness_of_fit real,
    efficiency real,
    significance real,
    flags bigint,
    conf_spectro_period real,
    r_pole_sum double precision,
    r_l1_point_sum double precision,
    r_spher_sum double precision,
    ecl_time_primary double precision,
    ecl_time_secondary double precision,
    ecl_dur_primary double precision,
    ecl_dur_secondary double precision,
    g_luminosity_ratio double precision,
    input_period_error real,
    g_rank double precision,
    astrometric_jitter double precision
);
COMMENT ON TABLE gaiadr3.nss_two_body_orbit IS 'This table contains non-single-star orbital models for sources compatible with an orbital two-body solution. This covers astrometric binaries, spectroscopic binaries, eclipsing binaries and certain combinations thereof. Several possible models are hosted within the same table and they are indicated by the field \texttt{nssSolutionType}. The description of this latter lists all possible solution types considered for this release. Only a selection of parameters hosted in this table are provided here, depending on the solution. The details of those is given in the description of field \texttt{bitIndex}, which can also be used to extract the relevant elements of the correlation vector \texttt{corrVec}. Details about the formalism used to derive the parameters in this table are given in the on-line documentation, see Chapter~\ref{chap:cu4nss}. Warning: as a source may receive independent astrometric, spectroscopic or photometric orbits, a query using a given sourceId may return several solutions. This has to be accounted for when doing a crossmatch by sourceId.';
COMMENT ON COLUMN gaiadr3.nss_two_body_orbit.solution_id IS 'Solution Identifier';
COMMENT ON COLUMN gaiadr3.nss_two_body_orbit.source_id IS 'Source Identifier';
COMMENT ON COLUMN gaiadr3.nss_two_body_orbit.nss_solution_type IS 'NSS model adopted';
COMMENT ON COLUMN gaiadr3.nss_two_body_orbit.ra IS 'Right ascension [deg]';
COMMENT ON COLUMN gaiadr3.nss_two_body_orbit.ra_error IS 'Standard error of right ascension [mas]';
COMMENT ON COLUMN gaiadr3.nss_two_body_orbit.dec IS 'Declination [deg]';
COMMENT ON COLUMN gaiadr3.nss_two_body_orbit.dec_error IS 'Standard error of declination [mas]';
COMMENT ON COLUMN gaiadr3.nss_two_body_orbit.parallax IS 'Parallax [mas]';
COMMENT ON COLUMN gaiadr3.nss_two_body_orbit.parallax_error IS 'Standard error of parallax [mas]';
COMMENT ON COLUMN gaiadr3.nss_two_body_orbit.pmra IS 'Proper motion in right ascension direction [mas.yr**-1]';
COMMENT ON COLUMN gaiadr3.nss_two_body_orbit.pmra_error IS 'Standard error of proper motion in right ascension direction [mas.yr**-1]';
COMMENT ON COLUMN gaiadr3.nss_two_body_orbit.pmdec IS 'Proper motion in declination direction [mas.yr**-1]';
COMMENT ON COLUMN gaiadr3.nss_two_body_orbit.pmdec_error IS 'Standard error of proper motion in declination direction [mas.yr**-1]';
COMMENT ON COLUMN gaiadr3.nss_two_body_orbit.a_thiele_innes IS 'Thiele-Innes element A [mas]';
COMMENT ON COLUMN gaiadr3.nss_two_body_orbit.a_thiele_innes_error IS 'Standard error of Thiele-Innes element A [mas]';
COMMENT ON COLUMN gaiadr3.nss_two_body_orbit.b_thiele_innes IS 'Thiele-Innes element B [mas]';
COMMENT ON COLUMN gaiadr3.nss_two_body_orbit.b_thiele_innes_error IS 'Standard error of Thiele-Innes element B [mas]';
COMMENT ON COLUMN gaiadr3.nss_two_body_orbit.f_thiele_innes IS 'Thiele-Innes element F [mas]';
COMMENT ON COLUMN gaiadr3.nss_two_body_orbit.f_thiele_innes_error IS 'Standard error of Thiele-Innes element F [mas]';
COMMENT ON COLUMN gaiadr3.nss_two_body_orbit.g_thiele_innes IS 'Thiele-Innes element G [mas]';
COMMENT ON COLUMN gaiadr3.nss_two_body_orbit.g_thiele_innes_error IS 'Standard error of Thiele-Innes element G [mas]';
COMMENT ON COLUMN gaiadr3.nss_two_body_orbit.c_thiele_innes IS 'C element of Thiele-Innes [AU]';
COMMENT ON COLUMN gaiadr3.nss_two_body_orbit.c_thiele_innes_error IS 'Standard error of C element of Thiele-Innes [AU]';
COMMENT ON COLUMN gaiadr3.nss_two_body_orbit.h_thiele_innes IS 'H element of Thiele-Innes [AU]';
COMMENT ON COLUMN gaiadr3.nss_two_body_orbit.h_thiele_innes_error IS 'Standard error of H element of Thiele-Innes [AU]';
COMMENT ON COLUMN gaiadr3.nss_two_body_orbit.period IS 'Orbital Period [d]';
COMMENT ON COLUMN gaiadr3.nss_two_body_orbit.period_error IS 'Standard error of Orbital Period [d]';
COMMENT ON COLUMN gaiadr3.nss_two_body_orbit.t_periastron IS 'Periastron epoch [d]';
COMMENT ON COLUMN gaiadr3.nss_two_body_orbit.t_periastron_error IS 'Standard error of Periastron epoch [d]';
COMMENT ON COLUMN gaiadr3.nss_two_body_orbit.eccentricity IS 'eccentricity';
COMMENT ON COLUMN gaiadr3.nss_two_body_orbit.eccentricity_error IS 'Standard error of eccentricity';
COMMENT ON COLUMN gaiadr3.nss_two_body_orbit.center_of_mass_velocity IS 'The velocity of the center of mass [km.s**-1]';
COMMENT ON COLUMN gaiadr3.nss_two_body_orbit.center_of_mass_velocity_error IS 'Standard error of The velocity of the center of mass [km.s**-1]';
COMMENT ON COLUMN gaiadr3.nss_two_body_orbit.semi_amplitude_primary IS 'Semi-amplitude of the center of mass [km.s**-1]';
COMMENT ON COLUMN gaiadr3.nss_two_body_orbit.semi_amplitude_primary_error IS 'Standard error of Semi-amplitude of the center of mass [km.s**-1]';
COMMENT ON COLUMN gaiadr3.nss_two_body_orbit.semi_amplitude_secondary IS 'The semiamplitude of the radial velocity curve for second component [km.s**-1]';
COMMENT ON COLUMN gaiadr3.nss_two_body_orbit.semi_amplitude_secondary_error IS 'Standard error of The semiamplitude of the radial velocity curve for second component [km.s**-1]';
COMMENT ON COLUMN gaiadr3.nss_two_body_orbit.mass_ratio IS 'Mass ratio';
COMMENT ON COLUMN gaiadr3.nss_two_body_orbit.mass_ratio_error IS 'Standard error of Mass ratio';
COMMENT ON COLUMN gaiadr3.nss_two_body_orbit.fill_factor_primary IS 'Fill factor of primary';
COMMENT ON COLUMN gaiadr3.nss_two_body_orbit.fill_factor_primary_error IS 'Standard error of Fill factor of primary';
COMMENT ON COLUMN gaiadr3.nss_two_body_orbit.fill_factor_secondary IS 'Fill factor of secondary';
COMMENT ON COLUMN gaiadr3.nss_two_body_orbit.fill_factor_secondary_error IS 'Standard error of Fill factor of secondary';
COMMENT ON COLUMN gaiadr3.nss_two_body_orbit.inclination IS 'Orbital inclination [deg]';
COMMENT ON COLUMN gaiadr3.nss_two_body_orbit.inclination_error IS 'Standard error of Orbital inclination [deg]';
COMMENT ON COLUMN gaiadr3.nss_two_body_orbit.arg_periastron IS 'Argument of periastron [deg]';
COMMENT ON COLUMN gaiadr3.nss_two_body_orbit.arg_periastron_error IS 'Standard error of Argument of periastron [deg]';
COMMENT ON COLUMN gaiadr3.nss_two_body_orbit.temperature_ratio IS 'Ratio of the effective temperatures';
COMMENT ON COLUMN gaiadr3.nss_two_body_orbit.temperature_ratio_error IS 'Standard error of the ratio of the effective temperatures';
COMMENT ON COLUMN gaiadr3.nss_two_body_orbit.temperature_ratio_definition IS 'Code defining which fitting scenario did apply to the effective temperature';
COMMENT ON COLUMN gaiadr3.nss_two_body_orbit.astrometric_n_obs_al IS 'Total astrometric CCD observations in AL considered';
COMMENT ON COLUMN gaiadr3.nss_two_body_orbit.astrometric_n_good_obs_al IS 'Total astrometric CCD observations in AL actually used';
COMMENT ON COLUMN gaiadr3.nss_two_body_orbit.rv_n_obs_primary IS 'Total number of radial velocities considered for the primary';
COMMENT ON COLUMN gaiadr3.nss_two_body_orbit.rv_n_good_obs_primary IS 'Total number of radial velocities actually used for the primary';
COMMENT ON COLUMN gaiadr3.nss_two_body_orbit.rv_n_obs_secondary IS 'Total number of radial velocities considered for the secondary in the case of SB2';
COMMENT ON COLUMN gaiadr3.nss_two_body_orbit.rv_n_good_obs_secondary IS 'Total number of radial velocities actually used for the secondary in the case of SB2';
COMMENT ON COLUMN gaiadr3.nss_two_body_orbit.phot_g_n_obs IS 'Total number of G photometry measurements considered';
COMMENT ON COLUMN gaiadr3.nss_two_body_orbit.phot_g_n_good_obs IS 'Total number of G photometry measurements actually used';
COMMENT ON COLUMN gaiadr3.nss_two_body_orbit.bit_index IS 'boolean mask for the fields above in the corrVec matrix';
COMMENT ON COLUMN gaiadr3.nss_two_body_orbit.corr_vec IS 'Vector form of the upper triangle of the correlation matrix (column-major ordered)';
COMMENT ON COLUMN gaiadr3.nss_two_body_orbit.obj_func IS 'value of the objective function at the solution';
COMMENT ON COLUMN gaiadr3.nss_two_body_orbit.goodness_of_fit IS 'goodness of fit in the Hipparcos sense';
COMMENT ON COLUMN gaiadr3.nss_two_body_orbit.efficiency IS 'Efficiency of the solution';
COMMENT ON COLUMN gaiadr3.nss_two_body_orbit.significance IS 'The significance of the solution (i.e. how worth keeping a model is)';
COMMENT ON COLUMN gaiadr3.nss_two_body_orbit.flags IS 'Quality flag for the achieved NSS solution';
COMMENT ON COLUMN gaiadr3.nss_two_body_orbit.conf_spectro_period IS 'The probability of the period for not being due to (gaussian white) noise. Relevant for SB1, SB1C, SB2 and SB2C models. To be ignored otherwise.';
COMMENT ON COLUMN gaiadr3.nss_two_body_orbit.r_pole_sum IS 'Sum of the polar radii of primary and secondary (in units of the semi-major axis)';
COMMENT ON COLUMN gaiadr3.nss_two_body_orbit.r_l1_point_sum IS 'L1-pointing radii of primary and secondary (in units of the semi-major axis)';
COMMENT ON COLUMN gaiadr3.nss_two_body_orbit.r_spher_sum IS 'Sum of the radii of sphere having the same volume as the primary and secondary (in units of the semi-major axis';
COMMENT ON COLUMN gaiadr3.nss_two_body_orbit.ecl_time_primary IS 'Time of mid-eclipse of the primary by the secondary [d]';
COMMENT ON COLUMN gaiadr3.nss_two_body_orbit.ecl_time_secondary IS 'Time of mid-eclipse of the secondary by the primary [d]';
COMMENT ON COLUMN gaiadr3.nss_two_body_orbit.ecl_dur_primary IS 'Duration of primary eclipse assuming spherical components [d]';
COMMENT ON COLUMN gaiadr3.nss_two_body_orbit.ecl_dur_secondary IS 'Duration of secondary eclipse assuming spherical components [d]';
COMMENT ON COLUMN gaiadr3.nss_two_body_orbit.g_luminosity_ratio IS 'Ratio of the G-band luminosity of the secondary over the primary';
COMMENT ON COLUMN gaiadr3.nss_two_body_orbit.input_period_error IS 'Standard error of the period taken from VariEclipsingBinary.frequencyError [d]';
COMMENT ON COLUMN gaiadr3.nss_two_body_orbit.g_rank IS 'Rank of the G-band solution';
COMMENT ON COLUMN gaiadr3.nss_two_body_orbit.astrometric_jitter IS 'Uncorrelated astrometric jitter term [mas]';
CREATE INDEX IF NOT EXISTS gaiadr3_nss_two_body_orbit_source_id_idx ON gaiadr3.nss_two_body_orbit (source_id);

-- [Estrellas no simples (binarias)] gaiadr3.nss_vim_fl — acceso: TAP Gaia (ADQL)
CREATE TABLE IF NOT EXISTS gaiadr3.nss_vim_fl (
    solution_id bigint,
    source_id bigint,
    nss_solution_type text,
    ra double precision,
    ra_error real,
    dec double precision,
    dec_error real,
    parallax double precision,
    parallax_error real,
    pmra double precision,
    pmra_error real,
    pmdec double precision,
    pmdec_error real,
    ref_flux_g real,
    vim_d_ra double precision,
    vim_d_ra_error real,
    vim_d_dec double precision,
    vim_d_dec_error real,
    astrometric_n_obs_al integer,
    astrometric_n_good_obs_al integer,
    bit_index bigint,
    corr_vec real[],
    obj_func real,
    goodness_of_fit real,
    efficiency real,
    significance real,
    flags bigint
);
COMMENT ON TABLE gaiadr3.nss_vim_fl IS 'This table contains non-single-star models for sources compatible with an Variability Induced Mover (VIM) solution. Several possible models are in principle hosted within the same table and they are indicated by the field \texttt{nssSolutionType}. The description of this latter lists all possible solution types considered for this release. Only a selection of parameters hosted in this table are provided here, depending on the solution. The details of those is given in the description of field \texttt{bitIndex}, which can also be used to extract the relevant elements of the correlation vector \texttt{corrVec}. For DR3, only VIMF solutions are provided here. Details about the formalism used to derive the parameters in this table are given in the on-line documentation, see Chapter~\ref{chap:cu4nss}.';
COMMENT ON COLUMN gaiadr3.nss_vim_fl.solution_id IS 'Solution Identifier';
COMMENT ON COLUMN gaiadr3.nss_vim_fl.source_id IS 'Source Identifier';
COMMENT ON COLUMN gaiadr3.nss_vim_fl.nss_solution_type IS 'NSS model adopted';
COMMENT ON COLUMN gaiadr3.nss_vim_fl.ra IS 'Right ascension [deg]';
COMMENT ON COLUMN gaiadr3.nss_vim_fl.ra_error IS 'Standard error of right ascension [mas]';
COMMENT ON COLUMN gaiadr3.nss_vim_fl.dec IS 'Declination [deg]';
COMMENT ON COLUMN gaiadr3.nss_vim_fl.dec_error IS 'Standard error of declination [mas]';
COMMENT ON COLUMN gaiadr3.nss_vim_fl.parallax IS 'Parallax [mas]';
COMMENT ON COLUMN gaiadr3.nss_vim_fl.parallax_error IS 'Standard error of parallax [mas]';
COMMENT ON COLUMN gaiadr3.nss_vim_fl.pmra IS 'Proper motion in right ascension direction [mas.yr**-1]';
COMMENT ON COLUMN gaiadr3.nss_vim_fl.pmra_error IS 'Standard error of proper motion in right ascension direction [mas.yr**-1]';
COMMENT ON COLUMN gaiadr3.nss_vim_fl.pmdec IS 'Proper motion in declination direction [mas.yr**-1]';
COMMENT ON COLUMN gaiadr3.nss_vim_fl.pmdec_error IS 'Standard error of proper motion in declination direction [mas.yr**-1]';
COMMENT ON COLUMN gaiadr3.nss_vim_fl.ref_flux_g IS 'Reference flux in the G band [''electron''.s**-1]';
COMMENT ON COLUMN gaiadr3.nss_vim_fl.vim_d_ra IS 'VIM coordinate in RA [mas]';
COMMENT ON COLUMN gaiadr3.nss_vim_fl.vim_d_ra_error IS 'Standard error of VIM coordinate in RA [mas]';
COMMENT ON COLUMN gaiadr3.nss_vim_fl.vim_d_dec IS 'VIM coordinate in DEC [mas]';
COMMENT ON COLUMN gaiadr3.nss_vim_fl.vim_d_dec_error IS 'Standard error of VIM coordinate in DEC [mas]';
COMMENT ON COLUMN gaiadr3.nss_vim_fl.astrometric_n_obs_al IS 'Total astrometric CCD observations in AL considered';
COMMENT ON COLUMN gaiadr3.nss_vim_fl.astrometric_n_good_obs_al IS 'Total astrometric CCD observations in AL actually used';
COMMENT ON COLUMN gaiadr3.nss_vim_fl.bit_index IS 'Boolean mask for the fields above in the corrVec matrix';
COMMENT ON COLUMN gaiadr3.nss_vim_fl.corr_vec IS 'Vector form of the upper triangle of the correlation matrix';
COMMENT ON COLUMN gaiadr3.nss_vim_fl.obj_func IS 'Value of the objective function at the solution';
COMMENT ON COLUMN gaiadr3.nss_vim_fl.goodness_of_fit IS 'Goodness of fit in the Hipparcos sense';
COMMENT ON COLUMN gaiadr3.nss_vim_fl.efficiency IS 'Efficiency of the solution';
COMMENT ON COLUMN gaiadr3.nss_vim_fl.significance IS 'The significance of the solution (i.e. how worth keeping a model is)';
COMMENT ON COLUMN gaiadr3.nss_vim_fl.flags IS 'Quality flag for the achieved NSS solution';
CREATE INDEX IF NOT EXISTS gaiadr3_nss_vim_fl_source_id_idx ON gaiadr3.nss_vim_fl (source_id);

-- [Verificación de rendimiento] gaiadr3.binary_masses — acceso: TAP Gaia (ADQL)
CREATE TABLE IF NOT EXISTS gaiadr3.binary_masses (
    source_id bigint,
    m1 real,
    m1_lower real,
    m1_upper real,
    m2 real,
    m2_lower real,
    m2_upper real,
    fluxratio real,
    fluxratio_lower real,
    fluxratio_upper real,
    combination_method text,
    m1_ref text,
    flag text
);
COMMENT ON TABLE gaiadr3.binary_masses IS 'Masses derived from the non-single stars (NSS) solutions with orbital parameters in table {\tt gaiadr3.nss\_two\_body\_orbit}. The table below is described in detail in \cite{DR3-DPACP-100}. The table presents the different types of NSS orbital solutions combined and which parameters each combination allows to constrain: \begin{tabular}{llccc} \hline\hline {\tt combinationMethod} & {\tt m1} & {\tt m2} & {\tt fluxratio} \\ \hline Orbital+SB2 & \checkmark & \checkmark & \checkmark \\ EclipsingSpectro(SB2) & \checkmark & \checkmark & \\ Eclipsing+SB2 & \checkmark & \checkmark & \\ AstroSpectroSB1+M1 & & \checkmark & \checkmark \\ Orbital+SB1+M1 & & \checkmark & \checkmark \\ EclipsingSpectro+M1 & & \checkmark & \\ Eclipsing+SB1+M1 & & \checkmark & \\ SB2+M1 & & \checkmark & \\ Orbital+M1 & & lower/upper & \\ SB1+M1 & & lower & \\ \hline \end{tabular}';
COMMENT ON COLUMN gaiadr3.binary_masses.source_id IS 'Source Identifier';
COMMENT ON COLUMN gaiadr3.binary_masses.m1 IS 'Primary mass [solMass]';
COMMENT ON COLUMN gaiadr3.binary_masses.m1_lower IS 'Lower confidence level (16%) of the primary mass [solMass]';
COMMENT ON COLUMN gaiadr3.binary_masses.m1_upper IS 'Upper confidence level (84%) of the primary mass [solMass]';
COMMENT ON COLUMN gaiadr3.binary_masses.m2 IS 'Secondary mass [solMass]';
COMMENT ON COLUMN gaiadr3.binary_masses.m2_lower IS 'Lower confidence level (16%) of the secondary mass [solMass]';
COMMENT ON COLUMN gaiadr3.binary_masses.m2_upper IS 'Upper confidence level (84%) of the secondary mass [solMass]';
COMMENT ON COLUMN gaiadr3.binary_masses.fluxratio IS 'Flux ratio of the secondary to the primary in the G-band';
COMMENT ON COLUMN gaiadr3.binary_masses.fluxratio_lower IS 'Lower value of the flux ratio';
COMMENT ON COLUMN gaiadr3.binary_masses.fluxratio_upper IS 'Upper value of the flux ratio';
COMMENT ON COLUMN gaiadr3.binary_masses.combination_method IS 'Combination of NSS solutions used';
COMMENT ON COLUMN gaiadr3.binary_masses.m1_ref IS 'Reference for the primary mass';
COMMENT ON COLUMN gaiadr3.binary_masses.flag IS 'Flag';
CREATE INDEX IF NOT EXISTS gaiadr3_binary_masses_source_id_idx ON gaiadr3.binary_masses (source_id);

-- [Verificación de rendimiento] gaiadr3.chemical_cartography — acceso: TAP Gaia (ADQL)
CREATE TABLE IF NOT EXISTS gaiadr3.chemical_cartography (
    solution_id bigint,
    source_id bigint,
    jr_med real,
    jz_med real,
    jphi_med real,
    rplane_med real,
    vrplane_med real,
    vz_med real,
    vphi_med real,
    zmax_med real,
    rapo_med real,
    rperi_med real,
    ecc_med real,
    x_med real,
    y_med real,
    z_med real,
    energy_med real,
    jr_hi real,
    jz_hi real,
    jphi_hi real,
    rplane_hi real,
    vrplane_hi real,
    vz_hi real,
    vphi_hi real,
    zmax_hi real,
    rapo_hi real,
    rperi_hi real,
    ecc_hi real,
    x_hi real,
    y_hi real,
    z_hi real,
    jr_lo real,
    jz_lo real,
    jphi_lo real,
    rplane_lo real,
    vrplane_lo real,
    vz_lo real,
    vphi_lo real,
    zmax_lo real,
    rapo_lo real,
    rperi_lo real,
    ecc_lo real,
    x_lo real,
    y_lo real,
    z_lo real
);
COMMENT ON TABLE gaiadr3.chemical_cartography IS 'Orbital parameters, actions, Galactocentric Cartesian coordinates and velocities for the sample of stars used in the DR3 chemical cartographic study of the Milky Way. For further details see \cite{DR3-DPACP-104}.';
COMMENT ON COLUMN gaiadr3.chemical_cartography.solution_id IS 'Solution Identifier';
COMMENT ON COLUMN gaiadr3.chemical_cartography.source_id IS 'Source Identifier';
COMMENT ON COLUMN gaiadr3.chemical_cartography.jr_med IS 'Median radial action per unit mass in units of 1967.3865 km/s kpc computed assuming the Staeckel approximation.';
COMMENT ON COLUMN gaiadr3.chemical_cartography.jz_med IS 'Median vertical action per unit mass in units of 1967.3865 km/s kpc computed assuming the Staeckel approximation.';
COMMENT ON COLUMN gaiadr3.chemical_cartography.jphi_med IS 'Median azimuthal action per unit mass (positive clockwise) in units of 1967.3865 km/s kpc. Equivalent to the median vertical component of the angular momentum.';
COMMENT ON COLUMN gaiadr3.chemical_cartography.rplane_med IS 'Median in-plane projection of the Galactocentric distance. [kpc]';
COMMENT ON COLUMN gaiadr3.chemical_cartography.vrplane_med IS 'Median Galactocentric radial velocity. [km.s**-1]';
COMMENT ON COLUMN gaiadr3.chemical_cartography.vz_med IS 'Median vertical velocity. [km.s**-1]';
COMMENT ON COLUMN gaiadr3.chemical_cartography.vphi_med IS 'Median Galactocentric azimuthal velocity (positive clockwise). [km.s**-1]';
COMMENT ON COLUMN gaiadr3.chemical_cartography.zmax_med IS 'Median maximum Galactic height (in absolute value) computed assuming the Staeckel approximation. [kpc]';
COMMENT ON COLUMN gaiadr3.chemical_cartography.rapo_med IS 'Median of the maximum Galactocentric distance computed assuming the Staeckel approximation. [kpc]';
COMMENT ON COLUMN gaiadr3.chemical_cartography.rperi_med IS 'Median of the minimum Galactocentric distance computed assuming the Staeckel approximation. [kpc]';
COMMENT ON COLUMN gaiadr3.chemical_cartography.ecc_med IS 'Median orbital eccentricity computed assuming the Staeckel approximation.';
COMMENT ON COLUMN gaiadr3.chemical_cartography.x_med IS 'Median of the Cartesian coordinate X. [kpc]';
COMMENT ON COLUMN gaiadr3.chemical_cartography.y_med IS 'Median of the Cartesian coordinate Y. [kpc]';
COMMENT ON COLUMN gaiadr3.chemical_cartography.z_med IS 'Median of the Cartesian coordinate Z. [kpc]';
COMMENT ON COLUMN gaiadr3.chemical_cartography.energy_med IS 'Total energy per unit mass assuming median coordinates and velocities. [km**2.s**-2]';
COMMENT ON COLUMN gaiadr3.chemical_cartography.jr_hi IS 'Upper confidence limit of the radial action per unit mass in units of 1967.3865 km/s kpc computed assuming the Staeckel approximation.';
COMMENT ON COLUMN gaiadr3.chemical_cartography.jz_hi IS 'Upper confidence limit of the vertical action per unit mass in units of 1967.3865 km/s kpc computed assuming the Staeckel approximation.';
COMMENT ON COLUMN gaiadr3.chemical_cartography.jphi_hi IS 'Upper confidence limit of the azimuthal action per unit mass (positive clockwise) in units of 1967.3865 km/s kpc.';
COMMENT ON COLUMN gaiadr3.chemical_cartography.rplane_hi IS 'Upper confidence limit of the in-plane projection of the Galactocentric distance. [kpc]';
COMMENT ON COLUMN gaiadr3.chemical_cartography.vrplane_hi IS 'Upper confidence limit of the Galactocentric radial velocity. [km.s**-1]';
COMMENT ON COLUMN gaiadr3.chemical_cartography.vz_hi IS 'Upper confidence limit of the vertical velocity. [km.s**-1]';
COMMENT ON COLUMN gaiadr3.chemical_cartography.vphi_hi IS 'Upper confidence limit of the Galactocentric azimuthal velocity (positive clockwise). Equivalent to the upper confidence limit of the vertical component of the angular momentum. [km.s**-1]';
COMMENT ON COLUMN gaiadr3.chemical_cartography.zmax_hi IS 'Upper confidence limit of the maximum Galactic height (in absolute value) computed assuming the Staeckel approximation. [kpc]';
COMMENT ON COLUMN gaiadr3.chemical_cartography.rapo_hi IS 'Upper confidence limit of the of the maximum Galactocentric distance computed assuming the Staeckel approximation. [kpc]';
COMMENT ON COLUMN gaiadr3.chemical_cartography.rperi_hi IS 'Upper confidence limit of the of the minimum Galactocentric distance computed assuming the Staeckel approximation. [kpc]';
COMMENT ON COLUMN gaiadr3.chemical_cartography.ecc_hi IS 'Upper confidence limit of the orbital eccentricity computed assuming the Staeckel approximation.';
COMMENT ON COLUMN gaiadr3.chemical_cartography.x_hi IS 'Upper confidence limit of the Cartesian coordinate X. [kpc]';
COMMENT ON COLUMN gaiadr3.chemical_cartography.y_hi IS 'Upper confidence limit of the Cartesian coordinate Y. [kpc]';
COMMENT ON COLUMN gaiadr3.chemical_cartography.z_hi IS 'Upper confidence limit of the Cartesian coordinate Z. [kpc]';
COMMENT ON COLUMN gaiadr3.chemical_cartography.jr_lo IS 'Lower confidence limit of the radial action per unit mass in units of 1967.3865 km/s kpc computed assuming the Staeckel approximation.';
COMMENT ON COLUMN gaiadr3.chemical_cartography.jz_lo IS 'Lower confidence limit of the vertical action per unit mass in units of 1967.3865 km/s kpc computed assuming the Staeckel approximation.';
COMMENT ON COLUMN gaiadr3.chemical_cartography.jphi_lo IS 'Lower confidence limit of the azimuthal action per unit mass (positive clockwise) in units of 1967.3865 km/s kpc. Equivalent to the lower confidence limit of the vertical component of the angular momentum.';
COMMENT ON COLUMN gaiadr3.chemical_cartography.rplane_lo IS 'Lower confidence limit of the in-plane projection of the Galactocentric distance. [kpc]';
COMMENT ON COLUMN gaiadr3.chemical_cartography.vrplane_lo IS 'Lower confidence limit of the Galactocentric radial velocity. [km.s**-1]';
COMMENT ON COLUMN gaiadr3.chemical_cartography.vz_lo IS 'Lower confidence limit of the vertical velocity. [km.s**-1]';
COMMENT ON COLUMN gaiadr3.chemical_cartography.vphi_lo IS 'Lower confidence limit of the Galactocentric azimuthal velocity (positive clockwise). [km.s**-1]';
COMMENT ON COLUMN gaiadr3.chemical_cartography.zmax_lo IS 'Lower confidence limit of the maximum Galactic height (in absolute value) computed assuming the Staeckel approximation. [kpc]';
COMMENT ON COLUMN gaiadr3.chemical_cartography.rapo_lo IS 'Lower confidence limit of the of the maximum Galactocentric distance computed assuming the Staeckel approximation. [kpc]';
COMMENT ON COLUMN gaiadr3.chemical_cartography.rperi_lo IS 'Lower confidence limit of the of the minimum Galactocentric distance computed assuming the Staeckel approximation. [kpc]';
COMMENT ON COLUMN gaiadr3.chemical_cartography.ecc_lo IS 'Lower confidence limit of the orbital eccentricity computed assuming the Staeckel approximation.';
COMMENT ON COLUMN gaiadr3.chemical_cartography.x_lo IS 'Lower confidence limit of the Cartesian coordinate X. [kpc]';
COMMENT ON COLUMN gaiadr3.chemical_cartography.y_lo IS 'Lower confidence limit of the Cartesian coordinate Y. [kpc]';
COMMENT ON COLUMN gaiadr3.chemical_cartography.z_lo IS 'Lower confidence limit of the Cartesian coordinate Z. [kpc]';
CREATE INDEX IF NOT EXISTS gaiadr3_chemical_cartography_source_id_idx ON gaiadr3.chemical_cartography (source_id);

-- [Verificación de rendimiento] gaiadr3.gold_sample_carbon_stars — acceso: TAP Gaia (ADQL)
CREATE TABLE IF NOT EXISTS gaiadr3.gold_sample_carbon_stars (
    source_id bigint
);
COMMENT ON TABLE gaiadr3.gold_sample_carbon_stars IS 'List of \textit{Gaia} DR3 source IDs for carbon stars extracted from the main list of candidate carbon stars for having C2 and CN molecular bands significantly stronger than usual M stars \citep{DR3-DPACP-123}.';
COMMENT ON COLUMN gaiadr3.gold_sample_carbon_stars.source_id IS 'Unique source identifier (unique within a particular Data Release)';
CREATE INDEX IF NOT EXISTS gaiadr3_gold_sample_carbon_stars_source_id_idx ON gaiadr3.gold_sample_carbon_stars (source_id);

-- [Verificación de rendimiento] gaiadr3.gold_sample_fgkm_stars — acceso: TAP Gaia (ADQL)
CREATE TABLE IF NOT EXISTS gaiadr3.gold_sample_fgkm_stars (
    source_id bigint,
    teff_gspphot real,
    logg_gspphot real,
    mh_gspphot real,
    ag_gspphot real,
    ebpminrp_gspphot real,
    alphafe_gspspec real,
    teff_gspspec real,
    logg_gspspec real,
    mh_gspspec real,
    radius_flame real,
    lum_flame real,
    mass_flame real,
    age_flame real,
    evolstage_flame integer,
    radius_flame_spec real,
    lum_flame_spec real,
    mass_flame_spec real,
    age_flame_spec real,
    evolstage_flame_spec integer,
    spectraltype_esphs text
);
COMMENT ON TABLE gaiadr3.gold_sample_fgkm_stars IS 'Stellar astrophysical parameters of the golden sample of F, G, K, and M stars from \cite{DR3-DPACP-123}. Values are identical to the ones in the \texttt{astrophysical\_parameters} and \texttt{astrophysical\_parameters\_supp} tables, but only those values retained after filtering are copied over.';
COMMENT ON COLUMN gaiadr3.gold_sample_fgkm_stars.source_id IS 'Unique source identifier (unique within a particular Data Release)';
COMMENT ON COLUMN gaiadr3.gold_sample_fgkm_stars.teff_gspphot IS 'Effective temperature from GSP-Phot Aeneas best library using BP/RP spectra [K]';
COMMENT ON COLUMN gaiadr3.gold_sample_fgkm_stars.logg_gspphot IS 'Surface gravity from GSP-Phot Aeneas best library using BP/RP spectra [log(cm.s**-2)]';
COMMENT ON COLUMN gaiadr3.gold_sample_fgkm_stars.mh_gspphot IS 'Global metallicity from GSP-Phot Aeneas best library using BP/RP spectra [''dex'']';
COMMENT ON COLUMN gaiadr3.gold_sample_fgkm_stars.ag_gspphot IS 'Extinction in G band from GSP-Phot Aeneas best library using BP/RP spectra [mag]';
COMMENT ON COLUMN gaiadr3.gold_sample_fgkm_stars.ebpminrp_gspphot IS 'Reddening E(BP-RP) from GSP-Phot Aeneas best library using BP/RP spectra [mag]';
COMMENT ON COLUMN gaiadr3.gold_sample_fgkm_stars.alphafe_gspspec IS 'Median abundance of alpha-elements [alphe/Fe] with respect to iron from GSP-Spec MatisseGauguin using RVS spectra and monte carlo realizations [''dex'']';
COMMENT ON COLUMN gaiadr3.gold_sample_fgkm_stars.teff_gspspec IS 'Median value of the effective temperature from GSP-Spec MatisseGauguin monte carlo realizations using RVS spectra [K]';
COMMENT ON COLUMN gaiadr3.gold_sample_fgkm_stars.logg_gspspec IS 'Median value of logarithm of the stellar surface gravity using RVS spectra and monte carlo realizations [log(cm.s**-2)]';
COMMENT ON COLUMN gaiadr3.gold_sample_fgkm_stars.mh_gspspec IS 'Median global metallicity [M/H] from GSP-Spec MatisseGauguin using RVS spectra and monte carlo realizations [''dex'']';
COMMENT ON COLUMN gaiadr3.gold_sample_fgkm_stars.radius_flame IS 'Radius of the star derived from FLAME using teffGspphot and lumFlame [solRad]';
COMMENT ON COLUMN gaiadr3.gold_sample_fgkm_stars.lum_flame IS 'Luminosity of the star from FLAME using G band magnitude, extinction (agGspphot), parallax and a bolometric correction (bcFlame) [solLum]';
COMMENT ON COLUMN gaiadr3.gold_sample_fgkm_stars.mass_flame IS 'Mass of the star from FLAME using stellar models, lumFlame, and teffGspphot [solMass]';
COMMENT ON COLUMN gaiadr3.gold_sample_fgkm_stars.age_flame IS 'Age of the star from FLAME using stellar models, see massFlame for details [Gyr]';
COMMENT ON COLUMN gaiadr3.gold_sample_fgkm_stars.evolstage_flame IS 'Evolutionary stage of the star derived from FLAME using stellar models, see massFlame for details';
COMMENT ON COLUMN gaiadr3.gold_sample_fgkm_stars.radius_flame_spec IS 'Radius of the star from FLAME using teffGspspec and lumFlameSpec [solRad]';
COMMENT ON COLUMN gaiadr3.gold_sample_fgkm_stars.lum_flame_spec IS 'Luminosity of the star from FLAME using G band magnitude, extinction (agGspphot), parallax and a bolometric correction (bcFlameSpec) [solLum]';
COMMENT ON COLUMN gaiadr3.gold_sample_fgkm_stars.mass_flame_spec IS 'Mass of the star from FLAME using stellar models, lumFlameSpec, and teffGspspec [solMass]';
COMMENT ON COLUMN gaiadr3.gold_sample_fgkm_stars.age_flame_spec IS 'Age of the star from FLAME using stellar models, see massFlameSpec for details [Gyr]';
COMMENT ON COLUMN gaiadr3.gold_sample_fgkm_stars.evolstage_flame_spec IS 'Evolutionary stage of the star derived from FLAME using stellar models, see massFlameSpec for details';
COMMENT ON COLUMN gaiadr3.gold_sample_fgkm_stars.spectraltype_esphs IS 'Spectral type from ESP-HS';
CREATE INDEX IF NOT EXISTS gaiadr3_gold_sample_fgkm_stars_source_id_idx ON gaiadr3.gold_sample_fgkm_stars (source_id);

-- [Verificación de rendimiento] gaiadr3.gold_sample_oba_stars — acceso: TAP Gaia (ADQL)
CREATE TABLE IF NOT EXISTS gaiadr3.gold_sample_oba_stars (
    source_id bigint,
    vtan_flag integer
);
COMMENT ON TABLE gaiadr3.gold_sample_oba_stars IS 'List of \textit{Gaia} DR3 source IDs of O, B, and A-type stars having an effective temperature estimate provided by ESP-HS or/and GSP-Phot greater than 7\,500~K. Based on the information available in the \textit{Gaia} DR3 catalogue, various filters were applied in order to reduce as much as possible the pollution from other types of targets. See \cite{DR3-DPACP-123} for more details.';
COMMENT ON COLUMN gaiadr3.gold_sample_oba_stars.source_id IS 'Unique source identifier (unique within a particular Data Release)';
COMMENT ON COLUMN gaiadr3.gold_sample_oba_stars.vtan_flag IS 'Flag indicating whether the tangential velocity is above 180 km/s';
CREATE INDEX IF NOT EXISTS gaiadr3_gold_sample_oba_stars_source_id_idx ON gaiadr3.gold_sample_oba_stars (source_id);

-- [Verificación de rendimiento] gaiadr3.gold_sample_solar_analogues — acceso: TAP Gaia (ADQL)
CREATE TABLE IF NOT EXISTS gaiadr3.gold_sample_solar_analogues (
    source_id bigint
);
COMMENT ON TABLE gaiadr3.gold_sample_solar_analogues IS '\textit{Gaia} DR3 source IDs of candidates for solar analogues selected from GSP-Spec via effective temperature, surface gravity and metallicity and from FLAME via mass and radius. For more details please refer to \cite{DR3-DPACP-123}.';
COMMENT ON COLUMN gaiadr3.gold_sample_solar_analogues.source_id IS 'Unique source identifier (unique within a particular Data Release)';
CREATE INDEX IF NOT EXISTS gaiadr3_gold_sample_solar_analogues_source_id_idx ON gaiadr3.gold_sample_solar_analogues (source_id);

-- [Verificación de rendimiento] gaiadr3.gold_sample_spss — acceso: TAP Gaia (ADQL)
CREATE TABLE IF NOT EXISTS gaiadr3.gold_sample_spss (
    source_id bigint,
    spss_id integer,
    spss_name text,
    spectraltype text,
    bin_flag integer,
    var_flag integer,
    teff real,
    teff_error real,
    logg real,
    logg_error real,
    feh real,
    feh_error real,
    alphafe real,
    alphafe_error real,
    radius real,
    radius_error real,
    lum real,
    lum_error real,
    mass real,
    mass_error real,
    age real,
    age_error real,
    azero real,
    azero_error real,
    ag real,
    ag_error real,
    ebpminrp real,
    ebpminrp_error real,
    distancepc real,
    distancepc_error real,
    radial_velocity real,
    radial_velocity_error real,
    vsini real,
    vsin_error real,
    notes text
);
COMMENT ON TABLE gaiadr3.gold_sample_spss IS 'Recommended parameters for the Gaia Spectro-Photometric Standard stars \citep{2021MNRAS.503.3660P}, selected as described in \cite{DR3-DPACP-123}, from the available parameters produced by CU8 \citep{DR3-DPACP-157} and CU6 \citep{DR3-DPACP-159}.';
COMMENT ON COLUMN gaiadr3.gold_sample_spss.source_id IS 'Unique source identifier (unique within a particular Data Release)';
COMMENT ON COLUMN gaiadr3.gold_sample_spss.spss_id IS 'SPSS identifier';
COMMENT ON COLUMN gaiadr3.gold_sample_spss.spss_name IS 'SPSS adopted name';
COMMENT ON COLUMN gaiadr3.gold_sample_spss.spectraltype IS 'Spectral type';
COMMENT ON COLUMN gaiadr3.gold_sample_spss.bin_flag IS 'Binary flag';
COMMENT ON COLUMN gaiadr3.gold_sample_spss.var_flag IS 'Variability flag';
COMMENT ON COLUMN gaiadr3.gold_sample_spss.teff IS 'Best effective temperature [K]';
COMMENT ON COLUMN gaiadr3.gold_sample_spss.teff_error IS 'Uncertainty of the best effective temperature [K]';
COMMENT ON COLUMN gaiadr3.gold_sample_spss.logg IS 'Best surface gravity [log(cm.s**-2)]';
COMMENT ON COLUMN gaiadr3.gold_sample_spss.logg_error IS 'Uncertainty on the best surface gravity [log(cm.s**-2)]';
COMMENT ON COLUMN gaiadr3.gold_sample_spss.feh IS 'Best iron abundance [''dex'']';
COMMENT ON COLUMN gaiadr3.gold_sample_spss.feh_error IS 'Uncertainty on the best iron abundance [''dex'']';
COMMENT ON COLUMN gaiadr3.gold_sample_spss.alphafe IS 'Best alpha enhancement [''dex'']';
COMMENT ON COLUMN gaiadr3.gold_sample_spss.alphafe_error IS 'Uncertainty on the best alpha enhancement [''dex'']';
COMMENT ON COLUMN gaiadr3.gold_sample_spss.radius IS 'Best radius [solRad]';
COMMENT ON COLUMN gaiadr3.gold_sample_spss.radius_error IS 'Uncertainty on the best radius [solRad]';
COMMENT ON COLUMN gaiadr3.gold_sample_spss.lum IS 'Best luminosity [solLum]';
COMMENT ON COLUMN gaiadr3.gold_sample_spss.lum_error IS 'Uncertainty on the best luminosity [solLum]';
COMMENT ON COLUMN gaiadr3.gold_sample_spss.mass IS 'Best mass [solMass]';
COMMENT ON COLUMN gaiadr3.gold_sample_spss.mass_error IS 'Uncertainty on the best mass [solMass]';
COMMENT ON COLUMN gaiadr3.gold_sample_spss.age IS 'Best age [Gyr]';
COMMENT ON COLUMN gaiadr3.gold_sample_spss.age_error IS 'Uncertainty on the best age [Gyr]';
COMMENT ON COLUMN gaiadr3.gold_sample_spss.azero IS 'Best extinction at 547.7 nm [mag]';
COMMENT ON COLUMN gaiadr3.gold_sample_spss.azero_error IS 'Uncertainty on the best extinction at 547.7 nm [mag]';
COMMENT ON COLUMN gaiadr3.gold_sample_spss.ag IS 'Extinction in the G band [mag]';
COMMENT ON COLUMN gaiadr3.gold_sample_spss.ag_error IS 'Uncertainty on the extinction in the G band [mag]';
COMMENT ON COLUMN gaiadr3.gold_sample_spss.ebpminrp IS 'Reddening in BP-RP [mag]';
COMMENT ON COLUMN gaiadr3.gold_sample_spss.ebpminrp_error IS 'Uncertainty on the reddening in BP-RP [mag]';
COMMENT ON COLUMN gaiadr3.gold_sample_spss.distancepc IS 'Best distance [pc]';
COMMENT ON COLUMN gaiadr3.gold_sample_spss.distancepc_error IS 'Uncertainty on the best distance [pc]';
COMMENT ON COLUMN gaiadr3.gold_sample_spss.radial_velocity IS 'Radial velocity [km.s**-1]';
COMMENT ON COLUMN gaiadr3.gold_sample_spss.radial_velocity_error IS 'Uncertainty on the radial velocity [km.s**-1]';
COMMENT ON COLUMN gaiadr3.gold_sample_spss.vsini IS 'Best projected rotation [km.s**-1]';
COMMENT ON COLUMN gaiadr3.gold_sample_spss.vsin_error IS 'Uncertainty on the best projected rotation [km.s**-1]';
COMMENT ON COLUMN gaiadr3.gold_sample_spss.notes IS 'Free text notes on this object';
CREATE INDEX IF NOT EXISTS gaiadr3_gold_sample_spss_source_id_idx ON gaiadr3.gold_sample_spss (source_id);

-- [Verificación de rendimiento] gaiadr3.gold_sample_ucd — acceso: TAP Gaia (ADQL)
CREATE TABLE IF NOT EXISTS gaiadr3.gold_sample_ucd (
    source_id bigint,
    ftot_fobs real,
    lum real,
    lum_uncertainty real,
    radius real,
    radius_uncertainty real,
    reduced_chi2 real
);
COMMENT ON TABLE gaiadr3.gold_sample_ucd IS 'The table contains the bolometric luminosities and radii in solar units for a subset of ultracool dwarfs from the Gaia DR3 catalogue, as well as some intermediate quantities used in the selection of sources and in the derivation of the luminosities and radii. For more details please refer to \cite{DR3-DPACP-123}.';
COMMENT ON COLUMN gaiadr3.gold_sample_ucd.source_id IS 'Unique source identifier (unique within a particular Data Release)';
COMMENT ON COLUMN gaiadr3.gold_sample_ucd.ftot_fobs IS 'Correction factor applied to obtain the total SED flux';
COMMENT ON COLUMN gaiadr3.gold_sample_ucd.lum IS 'Bolometric luminosity in solar units [solLum]';
COMMENT ON COLUMN gaiadr3.gold_sample_ucd.lum_uncertainty IS 'Uncertainty in bolometric luminosity [solLum]';
COMMENT ON COLUMN gaiadr3.gold_sample_ucd.radius IS 'Radius in solar unit [solRad]';
COMMENT ON COLUMN gaiadr3.gold_sample_ucd.radius_uncertainty IS 'Uncertainty in radius [solRad]';
COMMENT ON COLUMN gaiadr3.gold_sample_ucd.reduced_chi2 IS 'Reduced chi-square of the SED fit';
CREATE INDEX IF NOT EXISTS gaiadr3_gold_sample_ucd_source_id_idx ON gaiadr3.gold_sample_ucd (source_id);

-- [Verificación de rendimiento] gaiadr3.sso_orbits — acceso: TAP Gaia (ADQL)
CREATE TABLE IF NOT EXISTS gaiadr3.sso_orbits (
    number_mp integer,
    denomination text,
    osc_epoch double precision,
    mean_anomaly double precision,
    arg_perihelion double precision,
    long_asc_node double precision,
    inclination double precision,
    eccentricity double precision,
    semi_major_axis double precision,
    orbital_elements_var_covar_matrix double precision[],
    std_dev_semi_major_axis double precision,
    h_state_vector double precision[],
    h_state_vector_var_covar_matrix double precision[],
    arc_length double precision,
    num_observations integer
);
COMMENT ON TABLE gaiadr3.sso_orbits IS 'Orbital parameters and uncertainties computed from the {\tt sso\_observation} astrometric data. The content of the table is described in the DR3 publication \cite{DR3-DPACP-150}.';
COMMENT ON COLUMN gaiadr3.sso_orbits.number_mp IS 'SSO Number';
COMMENT ON COLUMN gaiadr3.sso_orbits.denomination IS 'Solar system object name';
COMMENT ON COLUMN gaiadr3.sso_orbits.osc_epoch IS 'Reference epoch for osculating orbit [d]';
COMMENT ON COLUMN gaiadr3.sso_orbits.mean_anomaly IS 'Mean anomaly [rad]';
COMMENT ON COLUMN gaiadr3.sso_orbits.arg_perihelion IS 'Argument of perihelion [rad]';
COMMENT ON COLUMN gaiadr3.sso_orbits.long_asc_node IS 'Longitude of ascending node [rad]';
COMMENT ON COLUMN gaiadr3.sso_orbits.inclination IS 'Inclination [rad]';
COMMENT ON COLUMN gaiadr3.sso_orbits.eccentricity IS 'Eccentricity';
COMMENT ON COLUMN gaiadr3.sso_orbits.semi_major_axis IS 'Semimajor axis [AU]';
COMMENT ON COLUMN gaiadr3.sso_orbits.orbital_elements_var_covar_matrix IS 'var-covar matrix on elliptical elements at reference Epoch';
COMMENT ON COLUMN gaiadr3.sso_orbits.std_dev_semi_major_axis IS 'Standard deviation on Semimajor axis [AU]';
COMMENT ON COLUMN gaiadr3.sso_orbits.h_state_vector IS 'Heliocentric State Vector at reference Epoch [''au, au.d**-1'']';
COMMENT ON COLUMN gaiadr3.sso_orbits.h_state_vector_var_covar_matrix IS 'Covariance matrix of the State Vector';
COMMENT ON COLUMN gaiadr3.sso_orbits.arc_length IS 'Orbital arc length spanned by the observations [d]';
COMMENT ON COLUMN gaiadr3.sso_orbits.num_observations IS 'Number of observations';

-- [Verificación de rendimiento] gaiadr3.synthetic_photometry_gspc — acceso: TAP Gaia (ADQL)
CREATE TABLE IF NOT EXISTS gaiadr3.synthetic_photometry_gspc (
    source_id bigint,
    c_star real,
    u_jkc_flux real,
    u_jkc_flux_error real,
    u_jkc_mag real,
    u_jkc_flag smallint,
    b_jkc_flux real,
    b_jkc_flux_error real,
    b_jkc_mag real,
    b_jkc_flag smallint,
    v_jkc_flux real,
    v_jkc_flux_error real,
    v_jkc_mag real,
    v_jkc_flag smallint,
    r_jkc_flux real,
    r_jkc_flux_error real,
    r_jkc_mag real,
    r_jkc_flag smallint,
    i_jkc_flux real,
    i_jkc_flux_error real,
    i_jkc_mag real,
    i_jkc_flag smallint,
    u_sdss_flux real,
    u_sdss_flux_error real,
    u_sdss_mag real,
    u_sdss_flag smallint,
    g_sdss_flux real,
    g_sdss_flux_error real,
    g_sdss_mag real,
    g_sdss_flag smallint,
    r_sdss_flux real,
    r_sdss_flux_error real,
    r_sdss_mag real,
    r_sdss_flag smallint,
    i_sdss_flux real,
    i_sdss_flux_error real,
    i_sdss_mag real,
    i_sdss_flag smallint,
    z_sdss_flux real,
    z_sdss_flux_error real,
    z_sdss_mag real,
    z_sdss_flag smallint,
    y_ps1_flux real,
    y_ps1_flux_error real,
    y_ps1_mag real,
    y_ps1_flag smallint,
    f606w_acswfc_flux real,
    f606w_acswfc_flux_error real,
    f606w_acswfc_mag real,
    f606w_acswfc_flag smallint,
    f814w_acswfc_flux real,
    f814w_acswfc_flux_error real,
    f814w_acswfc_mag real,
    f814w_acswfc_flag smallint
);
COMMENT ON TABLE gaiadr3.synthetic_photometry_gspc IS 'Gaia Synthetic Photometry Catalogue (GSPC) This is a catalogue of synthetic photometry generated from the Gaia BP/RP mean spectra in Data Release 3 and standardised using wide and reliable sets of external standard stars. Only sources that have BP/RP mean spectra in Gaia DR3 can be included in this catalogue. Individual magnitudes and fluxes are included only if $F/\sigma_F>30$ in that passband, where $F$ and $\sigma_F$ are the flux and its uncertainty. Synthetic photometry is provided in a selection of photometric systems. Further details on the generation and composition of the catalogue are available in \cite{DR3-DPACP-93}.';
COMMENT ON COLUMN gaiadr3.synthetic_photometry_gspc.source_id IS 'Unique source identifier (unique within a particular Data Release)';
COMMENT ON COLUMN gaiadr3.synthetic_photometry_gspc.c_star IS 'BP/RP excess factor corrected for the expected colour dependency';
COMMENT ON COLUMN gaiadr3.synthetic_photometry_gspc.u_jkc_flux IS 'U flux in the Johnson-Kron-Cousins system [W.m**-2.nm**-1]';
COMMENT ON COLUMN gaiadr3.synthetic_photometry_gspc.u_jkc_flux_error IS 'Error on the U flux in the Johnson-Kron-Cousins system [W.m**-2.nm**-1]';
COMMENT ON COLUMN gaiadr3.synthetic_photometry_gspc.u_jkc_mag IS 'U magnitude in the Johnson-Kron-Cousins system [mag]';
COMMENT ON COLUMN gaiadr3.synthetic_photometry_gspc.u_jkc_flag IS 'Flag indicating if G mag and BP-RP color of the source lie in the validated range';
COMMENT ON COLUMN gaiadr3.synthetic_photometry_gspc.b_jkc_flux IS 'B flux in the Johnson-Kron-Cousins system [W.m**-2.nm**-1]';
COMMENT ON COLUMN gaiadr3.synthetic_photometry_gspc.b_jkc_flux_error IS 'Error on the B flux in the Johnson-Kron-Cousins system [W.m**-2.nm**-1]';
COMMENT ON COLUMN gaiadr3.synthetic_photometry_gspc.b_jkc_mag IS 'B magnitude in the Johnson-Kron-Cousins system [mag]';
COMMENT ON COLUMN gaiadr3.synthetic_photometry_gspc.b_jkc_flag IS 'Flag indicating if G mag and BP-RP color of the source lie in the validated range';
COMMENT ON COLUMN gaiadr3.synthetic_photometry_gspc.v_jkc_flux IS 'V flux in the Johnson-Kron-Cousins system [W.m**-2.nm**-1]';
COMMENT ON COLUMN gaiadr3.synthetic_photometry_gspc.v_jkc_flux_error IS 'Error on the V flux in the Johnson-Kron-Cousins system [W.m**-2.nm**-1]';
COMMENT ON COLUMN gaiadr3.synthetic_photometry_gspc.v_jkc_mag IS 'V magnitude in the Johnson-Kron-Cousins system [mag]';
COMMENT ON COLUMN gaiadr3.synthetic_photometry_gspc.v_jkc_flag IS 'Flag indicating if G mag and BP-RP color of the source lie in the validated range';
COMMENT ON COLUMN gaiadr3.synthetic_photometry_gspc.r_jkc_flux IS 'R flux in the Johnson-Kron-Cousins system [W.m**-2.nm**-1]';
COMMENT ON COLUMN gaiadr3.synthetic_photometry_gspc.r_jkc_flux_error IS 'Error on the R flux in the Johnson-Kron-Cousins system [W.m**-2.nm**-1]';
COMMENT ON COLUMN gaiadr3.synthetic_photometry_gspc.r_jkc_mag IS 'R magnitude in the Johnson-Kron-Cousins system [mag]';
COMMENT ON COLUMN gaiadr3.synthetic_photometry_gspc.r_jkc_flag IS 'Flag indicating if G mag and BP-RP color of the source lie in the validated range';
COMMENT ON COLUMN gaiadr3.synthetic_photometry_gspc.i_jkc_flux IS 'I flux in the Johnson-Kron-Cousins system [W.m**-2.nm**-1]';
COMMENT ON COLUMN gaiadr3.synthetic_photometry_gspc.i_jkc_flux_error IS 'Error on the I flux in the Johnson-Kron-Cousins system [W.m**-2.nm**-1]';
COMMENT ON COLUMN gaiadr3.synthetic_photometry_gspc.i_jkc_mag IS 'I magnitude in the Johnson-Kron-Cousins system [mag]';
COMMENT ON COLUMN gaiadr3.synthetic_photometry_gspc.i_jkc_flag IS 'Flag indicating if G mag and BP-RP color of the source lie in the validated range';
COMMENT ON COLUMN gaiadr3.synthetic_photometry_gspc.u_sdss_flux IS 'u flux in the SDSS system [W.m**-2.nm**-1]';
COMMENT ON COLUMN gaiadr3.synthetic_photometry_gspc.u_sdss_flux_error IS 'Error on the u flux in the SDSS system [W.m**-2.nm**-1]';
COMMENT ON COLUMN gaiadr3.synthetic_photometry_gspc.u_sdss_mag IS 'u magnitude in the SDSS system [mag]';
COMMENT ON COLUMN gaiadr3.synthetic_photometry_gspc.u_sdss_flag IS 'Flag indicating if G mag and BP-RP color of the source lie in the validated range';
COMMENT ON COLUMN gaiadr3.synthetic_photometry_gspc.g_sdss_flux IS 'g flux in the SDSS system [W.m**-2.nm**-1]';
COMMENT ON COLUMN gaiadr3.synthetic_photometry_gspc.g_sdss_flux_error IS 'Error on the g flux in the SDSS system [W.m**-2.nm**-1]';
COMMENT ON COLUMN gaiadr3.synthetic_photometry_gspc.g_sdss_mag IS 'g magnitude in the SDSS system [mag]';
COMMENT ON COLUMN gaiadr3.synthetic_photometry_gspc.g_sdss_flag IS 'Flag indicating if G mag and BP-RP color of the source lie in the validated range';
COMMENT ON COLUMN gaiadr3.synthetic_photometry_gspc.r_sdss_flux IS 'r flux in the SDSS system [W.m**-2.nm**-1]';
COMMENT ON COLUMN gaiadr3.synthetic_photometry_gspc.r_sdss_flux_error IS 'Error on the r flux in the SDSS system [W.m**-2.nm**-1]';
COMMENT ON COLUMN gaiadr3.synthetic_photometry_gspc.r_sdss_mag IS 'r magnitude in the SDSS system [mag]';
COMMENT ON COLUMN gaiadr3.synthetic_photometry_gspc.r_sdss_flag IS 'Flag indicating if G mag and BP-RP color of the source lie in the validated range';
COMMENT ON COLUMN gaiadr3.synthetic_photometry_gspc.i_sdss_flux IS 'i flux in the SDSS system [W.m**-2.nm**-1]';
COMMENT ON COLUMN gaiadr3.synthetic_photometry_gspc.i_sdss_flux_error IS 'Error on the i flux in the SDSS system [W.m**-2.nm**-1]';
COMMENT ON COLUMN gaiadr3.synthetic_photometry_gspc.i_sdss_mag IS 'i magnitude in the SDSS system [mag]';
COMMENT ON COLUMN gaiadr3.synthetic_photometry_gspc.i_sdss_flag IS 'Flag indicating if G mag and BP-RP color of the source lie in the validated range';
COMMENT ON COLUMN gaiadr3.synthetic_photometry_gspc.z_sdss_flux IS 'z flux in the SDSS system [W.m**-2.nm**-1]';
COMMENT ON COLUMN gaiadr3.synthetic_photometry_gspc.z_sdss_flux_error IS 'Error on the z flux in the SDSS system [W.m**-2.nm**-1]';
COMMENT ON COLUMN gaiadr3.synthetic_photometry_gspc.z_sdss_mag IS 'z magnitude in the SDSS system [mag]';
COMMENT ON COLUMN gaiadr3.synthetic_photometry_gspc.z_sdss_flag IS 'Flag indicating if G mag and BP-RP color of the source lie in the validated range';
COMMENT ON COLUMN gaiadr3.synthetic_photometry_gspc.y_ps1_flux IS 'y flux in the Pan-STARRS1 system [W.m**-2.nm**-1]';
COMMENT ON COLUMN gaiadr3.synthetic_photometry_gspc.y_ps1_flux_error IS 'Error on the y flux in the Pan-STARRS1 system [W.m**-2.nm**-1]';
COMMENT ON COLUMN gaiadr3.synthetic_photometry_gspc.y_ps1_mag IS 'y magnitude in the Pan-STARRS1 system [mag]';
COMMENT ON COLUMN gaiadr3.synthetic_photometry_gspc.y_ps1_flag IS 'Flag indicating if G mag and BP-RP color of the source lie in the validated range';
COMMENT ON COLUMN gaiadr3.synthetic_photometry_gspc.f606w_acswfc_flux IS 'F606W flux in the HST ACS/WFC system [W.m**-2.nm**-1]';
COMMENT ON COLUMN gaiadr3.synthetic_photometry_gspc.f606w_acswfc_flux_error IS 'Error on the F606W flux in the HST ACS/WFC system [W.m**-2.nm**-1]';
COMMENT ON COLUMN gaiadr3.synthetic_photometry_gspc.f606w_acswfc_mag IS 'F606W magnitude in the HST ACS/WFC system [mag]';
COMMENT ON COLUMN gaiadr3.synthetic_photometry_gspc.f606w_acswfc_flag IS 'Flag indicating if G mag and BP-RP color of the source lie in the validated range';
COMMENT ON COLUMN gaiadr3.synthetic_photometry_gspc.f814w_acswfc_flux IS 'F814W flux in the HST ACS/WFC system [W.m**-2.nm**-1]';
COMMENT ON COLUMN gaiadr3.synthetic_photometry_gspc.f814w_acswfc_flux_error IS 'Error on the F814W flux in the HST ACS/WFC system [W.m**-2.nm**-1]';
COMMENT ON COLUMN gaiadr3.synthetic_photometry_gspc.f814w_acswfc_mag IS 'F814W magnitude in the HST ACS/WFC system [mag]';
COMMENT ON COLUMN gaiadr3.synthetic_photometry_gspc.f814w_acswfc_flag IS 'Flag indicating if G mag and BP-RP color of the source lie in the validated range';
CREATE INDEX IF NOT EXISTS gaiadr3_synthetic_photometry_gspc_source_id_idx ON gaiadr3.synthetic_photometry_gspc (source_id);

-- [Verificación de rendimiento] gaiadr3.vari_spurious_signals — acceso: TAP Gaia (ADQL)
CREATE TABLE IF NOT EXISTS gaiadr3.vari_spurious_signals (
    source_id bigint,
    phot_variable_flag text,
    in_andromeda_survey boolean,
    num_obs_common_all_bands smallint,
    num_obs_g_fov smallint,
    gls_freq_g_fov double precision,
    gls_freq_ampl_g_fov real,
    gls_freq_sde_g_fov real,
    gls_freq_fap_g_fov double precision,
    nhm_fund_freq_g_fov double precision,
    nhm_fund_freq_error_g_fov real,
    spearman_corr_exf_g_fov real,
    num_obs_excl_epsl_g_fov smallint,
    spearman_corr_ipd_g_fov real,
    scan_angle_model_offset_g_fov real,
    scan_angle_model_ampl_g_fov real,
    scan_angle_model_ampl_sig_g_fov real,
    scan_angle_model_phase_g_fov real,
    scan_angle_model_red_chi2_g_fov real,
    scan_angle_model_f2_g_fov real,
    spearman_corr_exf_bp real,
    num_obs_excl_epsl_bp smallint,
    spearman_corr_ipd_bp real,
    scan_angle_model_offset_bp real,
    scan_angle_model_ampl_bp real,
    scan_angle_model_ampl_sig_bp real,
    scan_angle_model_phase_bp real,
    scan_angle_model_red_chi2_bp real,
    scan_angle_model_f2_bp real,
    spearman_corr_exf_rp real,
    num_obs_excl_epsl_rp smallint,
    spearman_corr_ipd_rp real,
    scan_angle_model_offset_rp real,
    scan_angle_model_ampl_rp real,
    scan_angle_model_ampl_sig_rp real,
    scan_angle_model_phase_rp real,
    scan_angle_model_red_chi2_rp real,
    scan_angle_model_f2_rp real
);
COMMENT ON TABLE gaiadr3.vari_spurious_signals IS 'Several statistics computed for all sources with published photometric time series which can help in the identification of sources that are affected by calibration issues resulting in, for example, spurious variability signals. The table has a row for every source with {\tt GaiaSource.hasEpochPhotometry} set to TRUE and is described in detail in \cite{DR3-DPACP-164}.';
COMMENT ON COLUMN gaiadr3.vari_spurious_signals.source_id IS 'Source Identifier';
COMMENT ON COLUMN gaiadr3.vari_spurious_signals.phot_variable_flag IS 'Photometric variability flag';
COMMENT ON COLUMN gaiadr3.vari_spurious_signals.in_andromeda_survey IS 'Flag indicating that the source is present in the Gaia Andromeda Photometric Survey (GAPS)';
COMMENT ON COLUMN gaiadr3.vari_spurious_signals.num_obs_common_all_bands IS 'Number of observations in common for G, BP and RP bands, used in computation of the Spearman correlation excess factor fields';
COMMENT ON COLUMN gaiadr3.vari_spurious_signals.num_obs_g_fov IS 'Number of selected observations of G FoV transits, used in the frequency fields';
COMMENT ON COLUMN gaiadr3.vari_spurious_signals.gls_freq_g_fov IS 'Frequency identified by Generalised Least Squares period search on G FoV timeseries [d**-1]';
COMMENT ON COLUMN gaiadr3.vari_spurious_signals.gls_freq_ampl_g_fov IS 'Normalised amplitude of the frequency identified by Generalised Least Squares period search on G FoV timeseries';
COMMENT ON COLUMN gaiadr3.vari_spurious_signals.gls_freq_sde_g_fov IS 'Signal Detection Efficiency (SDE) of the frequency identified by Generalised Least Squares period search on G FoV timeseries';
COMMENT ON COLUMN gaiadr3.vari_spurious_signals.gls_freq_fap_g_fov IS 'False Alarm Probability (FAP) of the frequency identified by Generalised Least Squares period search on G FoV timeseries';
COMMENT ON COLUMN gaiadr3.vari_spurious_signals.nhm_fund_freq_g_fov IS 'Fundamental frequency identified by non-linear harmonic modelling on G FoV timeseries, initialised by the Generalised Least Squares frequency [d**-1]';
COMMENT ON COLUMN gaiadr3.vari_spurious_signals.nhm_fund_freq_error_g_fov IS 'Uncertainty of the fundamental frequency identified by non-linear harmonic modelling on G FoV timeseries [d**-1]';
COMMENT ON COLUMN gaiadr3.vari_spurious_signals.spearman_corr_exf_g_fov IS 'G-band FoV photometry Spearman correlation with corrected flux excess factor';
COMMENT ON COLUMN gaiadr3.vari_spurious_signals.num_obs_excl_epsl_g_fov IS 'Number of G-band FoV photometry observations excluding EPSL, used for the IPD correlation and scan angle modelling in the G band';
COMMENT ON COLUMN gaiadr3.vari_spurious_signals.spearman_corr_ipd_g_fov IS 'G-band FoV photometry Spearman correlation with IPD model';
COMMENT ON COLUMN gaiadr3.vari_spurious_signals.scan_angle_model_offset_g_fov IS 'Magnitude offset of the scan angle model fit to G-band FoV photometry [mag]';
COMMENT ON COLUMN gaiadr3.vari_spurious_signals.scan_angle_model_ampl_g_fov IS 'Amplitude of the scan angle model fit to G-band FoV photometry [mag]';
COMMENT ON COLUMN gaiadr3.vari_spurious_signals.scan_angle_model_ampl_sig_g_fov IS 'Significance of the amplitude of the scan angle model fit to G-band FoV photometry';
COMMENT ON COLUMN gaiadr3.vari_spurious_signals.scan_angle_model_phase_g_fov IS 'Phase of the scan angle model fit to G-band FoV photometry [deg]';
COMMENT ON COLUMN gaiadr3.vari_spurious_signals.scan_angle_model_red_chi2_g_fov IS 'Reduced Chi2 of the scan angle model fit to G-band FoV photometry';
COMMENT ON COLUMN gaiadr3.vari_spurious_signals.scan_angle_model_f2_g_fov IS 'F2 goodness-of-fit of the scan angle model fit to G-band FoV photometry';
COMMENT ON COLUMN gaiadr3.vari_spurious_signals.spearman_corr_exf_bp IS 'BP-band photometry Spearman correlation with corrected flux excess factor';
COMMENT ON COLUMN gaiadr3.vari_spurious_signals.num_obs_excl_epsl_bp IS 'Number of BP-band photometry observations excluding EPSL, used for the IPD correlation and scan angle modelling in the BP band';
COMMENT ON COLUMN gaiadr3.vari_spurious_signals.spearman_corr_ipd_bp IS 'BP-band Spearman correlation with IPD model';
COMMENT ON COLUMN gaiadr3.vari_spurious_signals.scan_angle_model_offset_bp IS 'Magnitude offset of the scan angle model fit to BP-band photometry [mag]';
COMMENT ON COLUMN gaiadr3.vari_spurious_signals.scan_angle_model_ampl_bp IS 'Amplitude of the scan angle model fit to BP-band photometry [mag]';
COMMENT ON COLUMN gaiadr3.vari_spurious_signals.scan_angle_model_ampl_sig_bp IS 'Significance of the amplitude of the scan angle model fit to BP-band photometry';
COMMENT ON COLUMN gaiadr3.vari_spurious_signals.scan_angle_model_phase_bp IS 'Phase of the scan angle model fit to BP-band photometry [deg]';
COMMENT ON COLUMN gaiadr3.vari_spurious_signals.scan_angle_model_red_chi2_bp IS 'Reduced Chi2 of the scan angle model fit to BP-band photometry';
COMMENT ON COLUMN gaiadr3.vari_spurious_signals.scan_angle_model_f2_bp IS 'F2 goodness-of-fit of the scan angle model fit to BP-band photometry';
COMMENT ON COLUMN gaiadr3.vari_spurious_signals.spearman_corr_exf_rp IS 'RP-band photometry Spearman correlation with corrected flux excess factor';
COMMENT ON COLUMN gaiadr3.vari_spurious_signals.num_obs_excl_epsl_rp IS 'Number of RP-band photometry observations excluding EPSL, used for the IPD correlation and scan angle modelling in the RP band';
COMMENT ON COLUMN gaiadr3.vari_spurious_signals.spearman_corr_ipd_rp IS 'RP-band Spearman correlation with IPD model';
COMMENT ON COLUMN gaiadr3.vari_spurious_signals.scan_angle_model_offset_rp IS 'Magnitude offset of the scan angle model fit to RP-band photometry [mag]';
COMMENT ON COLUMN gaiadr3.vari_spurious_signals.scan_angle_model_ampl_rp IS 'Amplitude of the scan angle model fit to RP-band photometry [mag]';
COMMENT ON COLUMN gaiadr3.vari_spurious_signals.scan_angle_model_ampl_sig_rp IS 'Significance of the amplitude of the scan angle model fit to RP-band photometry';
COMMENT ON COLUMN gaiadr3.vari_spurious_signals.scan_angle_model_phase_rp IS 'Phase of the scan angle model fit to RP-band photometry [deg]';
COMMENT ON COLUMN gaiadr3.vari_spurious_signals.scan_angle_model_red_chi2_rp IS 'Reduced Chi2 of the scan angle model fit to RP-band photometry';
COMMENT ON COLUMN gaiadr3.vari_spurious_signals.scan_angle_model_f2_rp IS 'F2 goodness-of-fit of the scan angle model fit to RP-band photometry';
CREATE INDEX IF NOT EXISTS gaiadr3_vari_spurious_signals_source_id_idx ON gaiadr3.vari_spurious_signals (source_id);

-- [Fotometría por época] gaiadr3.epoch_photometry — acceso: DataLink (EPOCH_PHOTOMETRY)
CREATE TABLE IF NOT EXISTS gaiadr3.epoch_photometry (
    solution_id bigint,
    source_id bigint,
    n_transits smallint,
    transit_id bigint[],
    g_transit_time double precision[],
    g_transit_flux double precision[],
    g_transit_flux_error double precision[],
    g_transit_flux_over_error real[],
    g_transit_mag double precision[],
    g_transit_n_obs smallint[],
    bp_obs_time double precision[],
    bp_flux double precision[],
    bp_flux_error double precision[],
    bp_flux_over_error real[],
    bp_mag double precision[],
    rp_obs_time double precision[],
    rp_flux double precision[],
    rp_flux_error double precision[],
    rp_flux_over_error real[],
    rp_mag double precision[],
    photometry_flag_noisy_data boolean[],
    photometry_flag_sm_unavailable boolean[],
    photometry_flag_af1_unavailable boolean[],
    photometry_flag_af2_unavailable boolean[],
    photometry_flag_af3_unavailable boolean[],
    photometry_flag_af4_unavailable boolean[],
    photometry_flag_af5_unavailable boolean[],
    photometry_flag_af6_unavailable boolean[],
    photometry_flag_af7_unavailable boolean[],
    photometry_flag_af8_unavailable boolean[],
    photometry_flag_af9_unavailable boolean[],
    photometry_flag_bp_unavailable boolean[],
    photometry_flag_rp_unavailable boolean[],
    photometry_flag_sm_reject boolean[],
    photometry_flag_af1_reject boolean[],
    photometry_flag_af2_reject boolean[],
    photometry_flag_af3_reject boolean[],
    photometry_flag_af4_reject boolean[],
    photometry_flag_af5_reject boolean[],
    photometry_flag_af6_reject boolean[],
    photometry_flag_af7_reject boolean[],
    photometry_flag_af8_reject boolean[],
    photometry_flag_af9_reject boolean[],
    photometry_flag_bp_reject boolean[],
    photometry_flag_rp_reject boolean[],
    variability_flag_g_reject boolean[],
    variability_flag_bp_reject boolean[],
    variability_flag_rp_reject boolean[]
);
COMMENT ON TABLE gaiadr3.epoch_photometry IS 'Epoch photometry. Each row in this table contains the light curve for a given object in bands G, BP and RP as stored in the DataLink Massive data base. This table makes extensive use of array types. It can be obtained selecting the RAW data structure option. A flat table (sparse cube), which one photometric point per source per row can be obtained using INDIVIDUAL or COMBINED. Note this table is not available through the main archive TAP interface. Data are delivered via the Massive Data service indexed by the VO Datalink protocol and described in Chapter~\ref{chap:archive}. For example this can be actioned in the archive user interface by querying the main source catalogue {\tt GaiaSource} and selecting {\tt hasEpochPhotometry}~{\tt = ''t''}.';
COMMENT ON COLUMN gaiadr3.epoch_photometry.solution_id IS 'Solution Identifier';
COMMENT ON COLUMN gaiadr3.epoch_photometry.source_id IS 'Unique source identifier (unique within a particular Data Release)';
COMMENT ON COLUMN gaiadr3.epoch_photometry.n_transits IS 'Number of Gaia transits';
COMMENT ON COLUMN gaiadr3.epoch_photometry.transit_id IS 'Transit unique identifier';
COMMENT ON COLUMN gaiadr3.epoch_photometry.g_transit_time IS 'Transit averaged G band observing time [d]';
COMMENT ON COLUMN gaiadr3.epoch_photometry.g_transit_flux IS 'Transit averaged G band flux [''electron''.s**-1]';
COMMENT ON COLUMN gaiadr3.epoch_photometry.g_transit_flux_error IS 'Transit averaged G band flux error [''electron''.s**-1]';
COMMENT ON COLUMN gaiadr3.epoch_photometry.g_transit_flux_over_error IS 'Transit averaged G band flux divided by its error';
COMMENT ON COLUMN gaiadr3.epoch_photometry.g_transit_mag IS 'Transit averaged G band Vega magnitude [mag]';
COMMENT ON COLUMN gaiadr3.epoch_photometry.g_transit_n_obs IS 'Number of CCD observations contributing to transit averaged G band flux';
COMMENT ON COLUMN gaiadr3.epoch_photometry.bp_obs_time IS 'BP CCD transit observing time [d]';
COMMENT ON COLUMN gaiadr3.epoch_photometry.bp_flux IS 'BP band flux [''electron''.s**-1]';
COMMENT ON COLUMN gaiadr3.epoch_photometry.bp_flux_error IS 'BP band flux error [''electron''.s**-1]';
COMMENT ON COLUMN gaiadr3.epoch_photometry.bp_flux_over_error IS 'BP band flux divided by its error';
COMMENT ON COLUMN gaiadr3.epoch_photometry.bp_mag IS 'BP band Vega magnitude [mag]';
COMMENT ON COLUMN gaiadr3.epoch_photometry.rp_obs_time IS 'RP CCD transit observing time [d]';
COMMENT ON COLUMN gaiadr3.epoch_photometry.rp_flux IS 'RP band flux [''electron''.s**-1]';
COMMENT ON COLUMN gaiadr3.epoch_photometry.rp_flux_error IS 'RP band flux error [''electron''.s**-1]';
COMMENT ON COLUMN gaiadr3.epoch_photometry.rp_flux_over_error IS 'RP band flux divided by its error';
COMMENT ON COLUMN gaiadr3.epoch_photometry.rp_mag IS 'RP band Vega magnitude [mag]';
COMMENT ON COLUMN gaiadr3.epoch_photometry.photometry_flag_noisy_data IS 'G band flux scatter larger than expected by photometry processing (all CCDs considered)';
COMMENT ON COLUMN gaiadr3.epoch_photometry.photometry_flag_sm_unavailable IS 'SM transit unavailable by photometry processing';
COMMENT ON COLUMN gaiadr3.epoch_photometry.photometry_flag_af1_unavailable IS 'AF1 transit unavailable by photometry processing';
COMMENT ON COLUMN gaiadr3.epoch_photometry.photometry_flag_af2_unavailable IS 'AF2 transit unavailable by photometry processing';
COMMENT ON COLUMN gaiadr3.epoch_photometry.photometry_flag_af3_unavailable IS 'AF3 transit unavailable by photometry processing';
COMMENT ON COLUMN gaiadr3.epoch_photometry.photometry_flag_af4_unavailable IS 'AF4 transit unavailable by photometry processing';
COMMENT ON COLUMN gaiadr3.epoch_photometry.photometry_flag_af5_unavailable IS 'AF5 transit unavailable by photometry processing';
COMMENT ON COLUMN gaiadr3.epoch_photometry.photometry_flag_af6_unavailable IS 'AF6 transit unavailable by photometry processing';
COMMENT ON COLUMN gaiadr3.epoch_photometry.photometry_flag_af7_unavailable IS 'AF7 transit unavailable by photometry processing';
COMMENT ON COLUMN gaiadr3.epoch_photometry.photometry_flag_af8_unavailable IS 'AF8 transit unavailable by photometry processing';
COMMENT ON COLUMN gaiadr3.epoch_photometry.photometry_flag_af9_unavailable IS 'AF9 transit unavailable by photometry processing';
COMMENT ON COLUMN gaiadr3.epoch_photometry.photometry_flag_bp_unavailable IS 'BP transit unavailable by photometry processing';
COMMENT ON COLUMN gaiadr3.epoch_photometry.photometry_flag_rp_unavailable IS 'RP transit unavailable by photometry processing';
COMMENT ON COLUMN gaiadr3.epoch_photometry.photometry_flag_sm_reject IS 'SM transit rejected by photometry processing';
COMMENT ON COLUMN gaiadr3.epoch_photometry.photometry_flag_af1_reject IS 'AF1 transit rejected by photometry processing';
COMMENT ON COLUMN gaiadr3.epoch_photometry.photometry_flag_af2_reject IS 'AF2 transit rejected by photometry processing';
COMMENT ON COLUMN gaiadr3.epoch_photometry.photometry_flag_af3_reject IS 'AF3 transit rejected by photometry processing';
COMMENT ON COLUMN gaiadr3.epoch_photometry.photometry_flag_af4_reject IS 'AF4 transit rejected by photometry processing';
COMMENT ON COLUMN gaiadr3.epoch_photometry.photometry_flag_af5_reject IS 'AF5 transit rejected by photometry processing';
COMMENT ON COLUMN gaiadr3.epoch_photometry.photometry_flag_af6_reject IS 'AF6 transit rejected by photometry processing';
COMMENT ON COLUMN gaiadr3.epoch_photometry.photometry_flag_af7_reject IS 'AF7 transit rejected by photometry processing';
COMMENT ON COLUMN gaiadr3.epoch_photometry.photometry_flag_af8_reject IS 'AF8 transit rejected by photometry processing';
COMMENT ON COLUMN gaiadr3.epoch_photometry.photometry_flag_af9_reject IS 'AF9 transit rejected by photometry processing';
COMMENT ON COLUMN gaiadr3.epoch_photometry.photometry_flag_bp_reject IS 'BP transit rejected by photometry processing';
COMMENT ON COLUMN gaiadr3.epoch_photometry.photometry_flag_rp_reject IS 'RP transit rejected by photometry processing';
COMMENT ON COLUMN gaiadr3.epoch_photometry.variability_flag_g_reject IS 'Average G transit photometry rejected by variability processing';
COMMENT ON COLUMN gaiadr3.epoch_photometry.variability_flag_bp_reject IS 'BP transit photometry rejected by variability processing';
COMMENT ON COLUMN gaiadr3.epoch_photometry.variability_flag_rp_reject IS 'RP transit photometry rejected by variability processing';
CREATE INDEX IF NOT EXISTS gaiadr3_epoch_photometry_source_id_idx ON gaiadr3.epoch_photometry (source_id);

-- [Marco de referencia] gaiadr3.agn_cross_id — acceso: TAP Gaia (ADQL)
CREATE TABLE IF NOT EXISTS gaiadr3.agn_cross_id (
    source_name_in_catalogue text,
    source_id bigint,
    catalogue_name text
);
COMMENT ON TABLE gaiadr3.agn_cross_id IS '<p>Table <tt>AgnCrossId</tt> lists sources whose positions and proper motions define the celestial reference frame of Gaia catalogue.</p> <p> <tt>AgnCrossId</tt> lists the sources in Gaia (E)DR3 cross-matched to sources in a number of external AGN catalogues. The first column is the sources identifier in the external catalogue specified in the third column, the second column is the source identifier in Gaia (E)DR3.</p> <p>The selection of sources and the quality of the Gaia-CRF3 are discussed in</p> <p>EDR3-DPACP-133.</p>';
COMMENT ON COLUMN gaiadr3.agn_cross_id.source_name_in_catalogue IS 'Identifier in the external catalogue';
COMMENT ON COLUMN gaiadr3.agn_cross_id.source_id IS 'Gaia source identifier';
COMMENT ON COLUMN gaiadr3.agn_cross_id.catalogue_name IS 'Name of the external catalogue';
CREATE INDEX IF NOT EXISTS gaiadr3_agn_cross_id_source_id_idx ON gaiadr3.agn_cross_id (source_id);

-- [Marco de referencia] gaiadr3.frame_rotator_source — acceso: TAP Gaia (ADQL)
CREATE TABLE IF NOT EXISTS gaiadr3.frame_rotator_source (
    source_id bigint,
    considered_for_reference_frame_orientation boolean,
    used_for_reference_frame_orientation boolean,
    considered_for_reference_frame_spin boolean,
    used_for_reference_frame_spin boolean
);
COMMENT ON TABLE gaiadr3.frame_rotator_source IS 'Sources used to compute the Gaia reference frame. The AGIS frame rotator algorithm has two different parts: the reference frame orientation; and the reference frame spin. The reference frame orientation is fixed using the International Earth Rotation and Reference System Service (=IERS) position of a subset of IERS sources defining the third realization of the International Coordinate Reference Frame (Charlot et al., 2020, submitted to A&A), http://hpiers.obspm.fr/icrs-pc/newwww/icrf/index.php. The reference frame spin is defined using the Gaia proper motion of a list of QSOs. The reference frame algorithms have an outliers scheme. Hence for each aspect we provide the considered sources and the used sources actually used, and the number of used sources might be lower than the number of considered sources.';
COMMENT ON COLUMN gaiadr3.frame_rotator_source.source_id IS 'Gaia source identifier';
COMMENT ON COLUMN gaiadr3.frame_rotator_source.considered_for_reference_frame_orientation IS 'Considered for the reference frame orientation';
COMMENT ON COLUMN gaiadr3.frame_rotator_source.used_for_reference_frame_orientation IS 'Used for the reference frame orientation';
COMMENT ON COLUMN gaiadr3.frame_rotator_source.considered_for_reference_frame_spin IS 'Considered for the reference frame spin';
COMMENT ON COLUMN gaiadr3.frame_rotator_source.used_for_reference_frame_spin IS 'Used for the reference frame spin';
CREATE INDEX IF NOT EXISTS gaiadr3_frame_rotator_source_source_id_idx ON gaiadr3.frame_rotator_source (source_id);

-- [Marco de referencia] gaiadr3.gaia_crf3_xm — acceso: TAP Gaia (ADQL)
CREATE TABLE IF NOT EXISTS gaiadr3.gaia_crf3_xm (
    solution_id bigint,
    source_id bigint,
    icrf3sx boolean,
    icrf3k boolean,
    icrf3xka boolean,
    icrf_name text,
    iers_name text,
    ocars boolean,
    ocars_name text,
    aw15 boolean,
    aw15_name text,
    r90 boolean,
    r90_name text,
    m65 boolean,
    m65_name text,
    c75 boolean,
    c75_name text,
    dr14q boolean,
    dr14q_name text,
    lqac5 boolean,
    lqac5_name text,
    lamost5 boolean,
    lamost5_name text,
    lqrf boolean,
    lqrf_name text,
    cat2qz boolean,
    cat2qz_name text,
    bzcat5 boolean,
    bzcat5_name text,
    cat2whspj boolean,
    cat2whspj_name text,
    alma19 boolean,
    alma19_name text,
    guw boolean,
    guw_name text,
    b19 boolean,
    b19_name text
);
COMMENT ON TABLE gaiadr3.gaia_crf3_xm IS 'This table contains the full cross-match information for the Gaia-CRF3 sources. The Gaia-CRF3 sources were selected from the cross-matches with 17 external QSO catalogues as detailed below (three of which are parts of ICRF3 described in the first paper). For each Gaia-CRF3 source the information in which external catalogue this source was found and which name(s) this source has in those external catalogues is provided. The table allows the user to get all sources from an external catalogue that are in Gaia-CRF3. The external catalogues from which the Gaia-CRF3 sources were compiled are: \begin{itemize} \item The third realization of the International Celestial Reference Frame by very long baseline interferometry \citep{2020A&A...644A.159C} \item A New Version of the OCARS Catalogue of Optical Characteristics of Astrometric Radio Sources \citep{2018ApJS..239...20M} (the catalogue downloaded from \url{http://www.gaoran.ru/english/as/ac_vlbi/#OCARS} on 17 June 2020) \item Identification of 1.4 Million Active Galactic Nuclei in the Mid-Infrared using WISE Data \citep{2015ApJS..221...12S} \item The WISE AGN Catalogue \citep{2018ApJS..234...23A} \item The Million Quasars (Milliquas) Catalogue, v6.4 \citep{2019arXiv191205614F} with the v6.5 (2020) update \item The Sloan Digital Sky Survey Quasar Catalogue: Fourteenth data release \citep{2018A&A...613A..51P} \item LQAC-5: The fifth release of the Large Quasar Astrometric Catalogue. A compilation of 592 809 objects with 398 697 Gaia counterparts \citep{2019A&A...624A.145S} \item The Large Sky Area Multi-object Fiber Spectroscopic Telescope (LAMOST) Quasar Survey: The Fourth and Fifth Data Releases \citep{2019ApJS..240....6Y} -- see also \url{https://nadc.china-vo.org/data/article/20190107155838} \item The large quasar reference frame (LQRF). An optical representation of the ICRS \citep{2009A&A...505..385A} \item The 2dF QSO Redshift Survey - XII. The spectroscopic catalogue and luminosity function \citep{2004MNRAS.349.1397C} \item The 5th edition of the Roma-BZCAT \citep{2015Ap&SS.357...75M} \item 2WHSP: A multi-frequency selected catalogue of high energy and very high energy {\ensuremath{\gamma}}-ray blazars and blazar candidates \citep{2017A&A...598A..17C} \item ALMA photometry of extragalactic radio sources \citep{2019MNRAS.485.1188B} \item Catalogues of active galactic nuclei from Gaia and unWISE data \citep{2019MNRAS.489.4741S} \item Quasar and galaxy classification in Gaia Data Release 2 \citep{2019MNRAS.490.5615B} \end{itemize}';
COMMENT ON COLUMN gaiadr3.gaia_crf3_xm.solution_id IS 'Solution Identifier';
COMMENT ON COLUMN gaiadr3.gaia_crf3_xm.source_id IS 'Gaia source identifier';
COMMENT ON COLUMN gaiadr3.gaia_crf3_xm.icrf3sx IS 'The flag describing if the Gaia-CRF3 source was found in ICRF3 S/X';
COMMENT ON COLUMN gaiadr3.gaia_crf3_xm.icrf3k IS 'The flag describing if the Gaia-CRF3 source was found in ICRF3 K';
COMMENT ON COLUMN gaiadr3.gaia_crf3_xm.icrf3xka IS 'The flag describing if the Gaia-CRF3 source was found in ICRF3 X/Ka';
COMMENT ON COLUMN gaiadr3.gaia_crf3_xm.icrf_name IS 'The ICRF name of the source';
COMMENT ON COLUMN gaiadr3.gaia_crf3_xm.iers_name IS 'The IERS name of the source';
COMMENT ON COLUMN gaiadr3.gaia_crf3_xm.ocars IS 'The flag describing if the Gaia-CRF3 source was found in OCARS';
COMMENT ON COLUMN gaiadr3.gaia_crf3_xm.ocars_name IS 'The name for this source in OCARS';
COMMENT ON COLUMN gaiadr3.gaia_crf3_xm.aw15 IS 'The flag describing if the Gaia-CRF3 source was found in allWISE';
COMMENT ON COLUMN gaiadr3.gaia_crf3_xm.aw15_name IS 'The name for this source in allWISE';
COMMENT ON COLUMN gaiadr3.gaia_crf3_xm.r90 IS 'The flag describing if the Gaia-CRF3 source was found in the catalogue R90';
COMMENT ON COLUMN gaiadr3.gaia_crf3_xm.r90_name IS 'The name for this source in R90';
COMMENT ON COLUMN gaiadr3.gaia_crf3_xm.m65 IS 'The flag describing if the Gaia-CRF3 source was found in Milliquas v6.5';
COMMENT ON COLUMN gaiadr3.gaia_crf3_xm.m65_name IS 'The name for this source in Milliquas v6.5';
COMMENT ON COLUMN gaiadr3.gaia_crf3_xm.c75 IS 'The flag describing if the Gaia-CRF3 source was found in the catalogue C75';
COMMENT ON COLUMN gaiadr3.gaia_crf3_xm.c75_name IS 'The name for this source in C75';
COMMENT ON COLUMN gaiadr3.gaia_crf3_xm.dr14q IS 'The flag describing if the Gaia-CRF3 source was found in the catalogue SDSS DR14Q';
COMMENT ON COLUMN gaiadr3.gaia_crf3_xm.dr14q_name IS 'The name for this source in SDSS DR14Q';
COMMENT ON COLUMN gaiadr3.gaia_crf3_xm.lqac5 IS 'The flag describing if the Gaia-CRF3 source was found in LQAC-5';
COMMENT ON COLUMN gaiadr3.gaia_crf3_xm.lqac5_name IS 'The name for this source in LQAC-5';
COMMENT ON COLUMN gaiadr3.gaia_crf3_xm.lamost5 IS 'The flag describing if the Gaia-CRF3 source was found in the LAMOST QSO catalogue';
COMMENT ON COLUMN gaiadr3.gaia_crf3_xm.lamost5_name IS 'The name for this source in the LAMOST QSO catalogue';
COMMENT ON COLUMN gaiadr3.gaia_crf3_xm.lqrf IS 'The flag describing if the Gaia-CRF3 source was found in LQRF';
COMMENT ON COLUMN gaiadr3.gaia_crf3_xm.lqrf_name IS 'The name for this source in LQRF';
COMMENT ON COLUMN gaiadr3.gaia_crf3_xm.cat2qz IS 'The flag describing if the Gaia-CRF3 source was found in 2QZ';
COMMENT ON COLUMN gaiadr3.gaia_crf3_xm.cat2qz_name IS 'The name for this source in 2QZ';
COMMENT ON COLUMN gaiadr3.gaia_crf3_xm.bzcat5 IS 'The flag describing if the Gaia-CRF3 source was found in Roma-BZCAT, v5';
COMMENT ON COLUMN gaiadr3.gaia_crf3_xm.bzcat5_name IS 'The name for this source in Roma-BZCAT, v5';
COMMENT ON COLUMN gaiadr3.gaia_crf3_xm.cat2whspj IS 'The flag describing if the Gaia-CRF3 source was found in 2WHSPJ';
COMMENT ON COLUMN gaiadr3.gaia_crf3_xm.cat2whspj_name IS 'The name for this source in 2WHSPJ';
COMMENT ON COLUMN gaiadr3.gaia_crf3_xm.alma19 IS 'The flag describing if the Gaia-CRF3 source was found in the ALMA calibrator catalogue';
COMMENT ON COLUMN gaiadr3.gaia_crf3_xm.alma19_name IS 'The name for this source in the ALMA calibrator catalogue';
COMMENT ON COLUMN gaiadr3.gaia_crf3_xm.guw IS 'The flag describing if the Gaia-CRF3 source was found in Gaia-unWISE';
COMMENT ON COLUMN gaiadr3.gaia_crf3_xm.guw_name IS 'The name for this source in Gaia-unWISE';
COMMENT ON COLUMN gaiadr3.gaia_crf3_xm.b19 IS 'The flag describing if the Gaia-CRF3 source was found in the Gaia DR2 quasar and galaxy classification catalogue';
COMMENT ON COLUMN gaiadr3.gaia_crf3_xm.b19_name IS 'The name for this source in the Gaia DR2 quasar and galaxy classification catalogue';
CREATE INDEX IF NOT EXISTS gaiadr3_gaia_crf3_xm_source_id_idx ON gaiadr3.gaia_crf3_xm (source_id);

-- [Alertas científicas] gaiadr3.alerts_mixedin_sourceids — acceso: TAP Gaia (ADQL)
CREATE TABLE IF NOT EXISTS gaiadr3.alerts_mixedin_sourceids (
    solution_id bigint,
    alert_source_id bigint,
    mixed_in_source_id bigint
);
COMMENT ON TABLE gaiadr3.alerts_mixedin_sourceids IS 'Some photometric science alerts mix transits from their primary source and other sources in the catalogue. This is done when those sources are believed to be associated with a single, astrophysical source. This table lists the identifier for these mixed-in sources, linking them to the primary sourceIds listed in table \texttt{ScienceAlerts}.';
COMMENT ON COLUMN gaiadr3.alerts_mixedin_sourceids.solution_id IS 'Solution Identifier';
COMMENT ON COLUMN gaiadr3.alerts_mixedin_sourceids.alert_source_id IS 'Primary sourceId associated to the alert';
COMMENT ON COLUMN gaiadr3.alerts_mixedin_sourceids.mixed_in_source_id IS 'Additional sourceId, if any, associated to the alert';

-- [Alertas científicas] gaiadr3.science_alerts — acceso: TAP Gaia (ADQL)
CREATE TABLE IF NOT EXISTS gaiadr3.science_alerts (
    source_id bigint,
    transit_id bigint,
    name text,
    solution_id bigint
);
COMMENT ON TABLE gaiadr3.science_alerts IS 'Table containing all Gaia Photometric Science Alerts triggered in the period 25-07-2014 to 28-05-2017, i.e.~the time span covered by DR3. A Gaia Photometric Science Alert is known to the community by its name Gaiannxyz where nn is the year number and xyz is an incrementing, alphabetic sequence starting at aaa. Science alerts have their details published on the WWW. Given the name of an alert, the URL for the published details can be derived, e.g. \url{https://gsaweb.ast.cam.ac.uk/alerts/alert/Gaia18ahj} for alert Gaia18ahj. The {\tt sourceId} associated to the alert may have other alternative matches in Gaia DR3. These other identifiers are listed in table \texttt{AlertsMixedinSourceids}.';
COMMENT ON COLUMN gaiadr3.science_alerts.source_id IS 'Unique source identifier (unique within a particular Data Release)';
COMMENT ON COLUMN gaiadr3.science_alerts.transit_id IS 'Alerting transit identifier';
COMMENT ON COLUMN gaiadr3.science_alerts.name IS 'Name of alert';
COMMENT ON COLUMN gaiadr3.science_alerts.solution_id IS 'Solution Identifier';
CREATE INDEX IF NOT EXISTS gaiadr3_science_alerts_source_id_idx ON gaiadr3.science_alerts (source_id);

-- [Sistema solar] gaiadr3.sso_observation — acceso: TAP Gaia (ADQL)
CREATE TABLE IF NOT EXISTS gaiadr3.sso_observation (
    solution_id bigint,
    source_id bigint,
    denomination text,
    transit_id bigint,
    observation_id bigint,
    number_mp bigint,
    epoch double precision,
    epoch_err double precision,
    epoch_utc double precision,
    ra double precision,
    dec double precision,
    ra_error_systematic double precision,
    dec_error_systematic double precision,
    ra_dec_correlation_systematic double precision,
    ra_error_random double precision,
    dec_error_random double precision,
    ra_dec_correlation_random double precision,
    g_mag double precision,
    g_flux double precision,
    g_flux_error double precision,
    x_gaia double precision,
    y_gaia double precision,
    z_gaia double precision,
    vx_gaia double precision,
    vy_gaia double precision,
    vz_gaia double precision,
    x_gaia_geocentric double precision,
    y_gaia_geocentric double precision,
    z_gaia_geocentric double precision,
    vx_gaia_geocentric double precision,
    vy_gaia_geocentric double precision,
    vz_gaia_geocentric double precision,
    position_angle_scan double precision,
    astrometric_outcome_ccd integer[],
    astrometric_outcome_transit integer
);
COMMENT ON TABLE gaiadr3.sso_observation IS 'Solar System object observations. Each table line contained data obtained during the transit of the source on a single CCD, during a single transit. The corresponding epoch is provided. Data not varying within the transit are repeated identically for all single observations of that transit.';
COMMENT ON COLUMN gaiadr3.sso_observation.solution_id IS 'Solution Identifier';
COMMENT ON COLUMN gaiadr3.sso_observation.source_id IS 'Source identifier';
COMMENT ON COLUMN gaiadr3.sso_observation.denomination IS 'standard MPC denomination of the asteroid';
COMMENT ON COLUMN gaiadr3.sso_observation.transit_id IS 'Transit Identifier';
COMMENT ON COLUMN gaiadr3.sso_observation.observation_id IS 'Observation Identifier';
COMMENT ON COLUMN gaiadr3.sso_observation.number_mp IS 'Minor Planet number';
COMMENT ON COLUMN gaiadr3.sso_observation.epoch IS 'Gaia-centric epoch TCB(Gaia) [d]';
COMMENT ON COLUMN gaiadr3.sso_observation.epoch_err IS 'Error in Gaiacentric epoch [d]';
COMMENT ON COLUMN gaiadr3.sso_observation.epoch_utc IS 'Gaia-centric TCB epoch converted to UTC [d]';
COMMENT ON COLUMN gaiadr3.sso_observation.ra IS 'Right ascension of the source [deg]';
COMMENT ON COLUMN gaiadr3.sso_observation.dec IS 'Declination of the source [deg]';
COMMENT ON COLUMN gaiadr3.sso_observation.ra_error_systematic IS 'Standard error of right ascension - systematic [mas]';
COMMENT ON COLUMN gaiadr3.sso_observation.dec_error_systematic IS 'Standard error of declination - systematic [mas]';
COMMENT ON COLUMN gaiadr3.sso_observation.ra_dec_correlation_systematic IS 'Correlation of ra and dec errors - systematic';
COMMENT ON COLUMN gaiadr3.sso_observation.ra_error_random IS 'Standard error of right ascension - random [mas]';
COMMENT ON COLUMN gaiadr3.sso_observation.dec_error_random IS 'Standard error of declination - random [mas]';
COMMENT ON COLUMN gaiadr3.sso_observation.ra_dec_correlation_random IS 'Correlation of ra and dec errors - random';
COMMENT ON COLUMN gaiadr3.sso_observation.g_mag IS 'Calibrated G mag [mag]';
COMMENT ON COLUMN gaiadr3.sso_observation.g_flux IS 'Average calibrated G flux for the transit [''electron''.s**-1]';
COMMENT ON COLUMN gaiadr3.sso_observation.g_flux_error IS 'Error on the G flux [''electron''.s**-1]';
COMMENT ON COLUMN gaiadr3.sso_observation.x_gaia IS 'Barycentric x position of Gaia [AU]';
COMMENT ON COLUMN gaiadr3.sso_observation.y_gaia IS 'Barycentric y position of Gaia [AU]';
COMMENT ON COLUMN gaiadr3.sso_observation.z_gaia IS 'Barycentric z position of Gaia [AU]';
COMMENT ON COLUMN gaiadr3.sso_observation.vx_gaia IS 'Barycentric x velocity of Gaia [AU.d**-1]';
COMMENT ON COLUMN gaiadr3.sso_observation.vy_gaia IS 'Barycentric y velocity of Gaia [AU.d**-1]';
COMMENT ON COLUMN gaiadr3.sso_observation.vz_gaia IS 'Barycentric z velocity of Gaia [AU.d**-1]';
COMMENT ON COLUMN gaiadr3.sso_observation.x_gaia_geocentric IS 'Geocentric x position of Gaia [AU]';
COMMENT ON COLUMN gaiadr3.sso_observation.y_gaia_geocentric IS 'Geocentric y position of Gaia [AU]';
COMMENT ON COLUMN gaiadr3.sso_observation.z_gaia_geocentric IS 'Geocentric z position of Gaia [AU]';
COMMENT ON COLUMN gaiadr3.sso_observation.vx_gaia_geocentric IS 'Geocentric x velocity of Gaia [AU.d**-1]';
COMMENT ON COLUMN gaiadr3.sso_observation.vy_gaia_geocentric IS 'Geocentric y velocity of Gaia [AU.d**-1]';
COMMENT ON COLUMN gaiadr3.sso_observation.vz_gaia_geocentric IS 'Geocentric z velocity of Gaia [AU.d**-1]';
COMMENT ON COLUMN gaiadr3.sso_observation.position_angle_scan IS 'Position angle of the scanning direction [deg]';
COMMENT ON COLUMN gaiadr3.sso_observation.astrometric_outcome_ccd IS 'Result of processing the CCDs';
COMMENT ON COLUMN gaiadr3.sso_observation.astrometric_outcome_transit IS 'Result of processing the transit';
CREATE INDEX IF NOT EXISTS gaiadr3_sso_observation_source_id_idx ON gaiadr3.sso_observation (source_id);

-- [Sistema solar] gaiadr3.sso_reflectance_spectrum — acceso: TAP Gaia (ADQL)
CREATE TABLE IF NOT EXISTS gaiadr3.sso_reflectance_spectrum (
    source_id bigint,
    solution_id bigint,
    number_mp bigint,
    denomination text,
    nb_samples smallint,
    num_of_spectra integer,
    reflectance_spectrum real,
    reflectance_spectrum_err real,
    wavelength real,
    reflectance_spectrum_flag smallint
);
COMMENT ON TABLE gaiadr3.sso_reflectance_spectrum IS 'This table contains the mean BP/RP reflectance spectra of asteroids computed as the ratio between the asteroid flux and an averaged solar analogue flux. In each row, the reflectance spectrum of a given asteroid is given at a given wavelength. Entries for all asteroids are concatenated into a single table.';
COMMENT ON COLUMN gaiadr3.sso_reflectance_spectrum.source_id IS 'Source identifier';
COMMENT ON COLUMN gaiadr3.sso_reflectance_spectrum.solution_id IS 'Solution Identifier';
COMMENT ON COLUMN gaiadr3.sso_reflectance_spectrum.number_mp IS 'Minor Planet number';
COMMENT ON COLUMN gaiadr3.sso_reflectance_spectrum.denomination IS 'standard MPC denomination of the asteroid';
COMMENT ON COLUMN gaiadr3.sso_reflectance_spectrum.nb_samples IS 'Nb samples in spectrum';
COMMENT ON COLUMN gaiadr3.sso_reflectance_spectrum.num_of_spectra IS 'number of epoch spectra used to compute the average';
COMMENT ON COLUMN gaiadr3.sso_reflectance_spectrum.reflectance_spectrum IS 'Reflectance spectrum';
COMMENT ON COLUMN gaiadr3.sso_reflectance_spectrum.reflectance_spectrum_err IS 'Error in reflectance spectrum';
COMMENT ON COLUMN gaiadr3.sso_reflectance_spectrum.wavelength IS 'Internally-calibrated wavelength of reflectance spectrum [nm]';
COMMENT ON COLUMN gaiadr3.sso_reflectance_spectrum.reflectance_spectrum_flag IS 'Reflectance spectrum value flag';
CREATE INDEX IF NOT EXISTS gaiadr3_sso_reflectance_spectrum_source_id_idx ON gaiadr3.sso_reflectance_spectrum (source_id);

-- [Sistema solar] gaiadr3.sso_source — acceso: TAP Gaia (ADQL)
CREATE TABLE IF NOT EXISTS gaiadr3.sso_source (
    solution_id bigint,
    source_id bigint,
    num_of_obs integer,
    number_mp bigint,
    denomination text,
    num_of_spectra integer
);
COMMENT ON TABLE gaiadr3.sso_source IS 'This table contains data related to Solar System objects observed by Gaia. The quantities in the table are derived from data reduction and are associated to single objects.';
COMMENT ON COLUMN gaiadr3.sso_source.solution_id IS 'Solution Identifier';
COMMENT ON COLUMN gaiadr3.sso_source.source_id IS 'Source identifier';
COMMENT ON COLUMN gaiadr3.sso_source.num_of_obs IS 'number of observations';
COMMENT ON COLUMN gaiadr3.sso_source.number_mp IS 'Minor Planet number';
COMMENT ON COLUMN gaiadr3.sso_source.denomination IS 'standard MPC denomination of the asteroid';
COMMENT ON COLUMN gaiadr3.sso_source.num_of_spectra IS 'Number of epoch spectra used to compute the average';
CREATE INDEX IF NOT EXISTS gaiadr3_sso_source_source_id_idx ON gaiadr3.sso_source (source_id);

-- [Espectroscopía] gaiadr3.rvs_mean_spectrum — acceso: DataLink (RVS)
CREATE TABLE IF NOT EXISTS gaiadr3.rvs_mean_spectrum (
    source_id bigint,
    solution_id bigint,
    ra double precision,
    dec double precision,
    flux real[],
    flux_error real[],
    combined_transits smallint,
    combined_ccds smallint,
    deblended_ccds smallint
);
COMMENT ON TABLE gaiadr3.rvs_mean_spectrum IS 'This is the RVS mean sampled spectrum table. The spectra are in the rest frame, they are normalised and their wavelength grid ranges from 846 to 870 nm in steps of 0.01 nm (2401 elements). See~~\secref{sssec:cu6spe_meanspe} for a description on how the mean spectra are obtained, and \citet{DR3-DPACP-154} for a description of the spectra validation. Note this table is not available through the main archive TAP interface, but via the Massive Data service, indexed by the VO Datalink protocol, described in Chapter~\ref{chap:archive}. For example this can be actioned in the archive user interface by querying the main source catalogue {\tt GaiaSource} and selecting {\tt hasRvs}~{\tt = ''t''}. The following columns are available in table format only if the `RAW'' option is selected in the Datalink pop-up window. If the `INDIVIDUAL'' or `COMBINED'' options are chosen, all columns other than {\tt flux} and {\tt fluxError} are provided in the header of the xml file, while wavelength, {\tt flux} and {\tt fluxError} columns are provided in table format.';
COMMENT ON COLUMN gaiadr3.rvs_mean_spectrum.source_id IS 'Unique source identifier (unique within a particular Data Release)';
COMMENT ON COLUMN gaiadr3.rvs_mean_spectrum.solution_id IS 'Solution Identifier';
COMMENT ON COLUMN gaiadr3.rvs_mean_spectrum.ra IS 'Right Ascension [deg]';
COMMENT ON COLUMN gaiadr3.rvs_mean_spectrum.dec IS 'Declination [deg]';
COMMENT ON COLUMN gaiadr3.rvs_mean_spectrum.flux IS 'array of fluxes';
COMMENT ON COLUMN gaiadr3.rvs_mean_spectrum.flux_error IS 'array of uncertainties in flux';
COMMENT ON COLUMN gaiadr3.rvs_mean_spectrum.combined_transits IS 'number of combined transits';
COMMENT ON COLUMN gaiadr3.rvs_mean_spectrum.combined_ccds IS 'number of combined CCD spectra';
COMMENT ON COLUMN gaiadr3.rvs_mean_spectrum.deblended_ccds IS 'number of deblended CCD spectra';
CREATE INDEX IF NOT EXISTS gaiadr3_rvs_mean_spectrum_source_id_idx ON gaiadr3.rvs_mean_spectrum (source_id);

-- [Espectroscopía] gaiadr3.xp_continuous_mean_spectrum — acceso: DataLink (XP_CONTINUOUS)
CREATE TABLE IF NOT EXISTS gaiadr3.xp_continuous_mean_spectrum (
    source_id bigint,
    solution_id bigint,
    bp_basis_function_id smallint,
    bp_degrees_of_freedom smallint,
    bp_n_parameters smallint,
    bp_n_measurements smallint,
    bp_n_rejected_measurements smallint,
    bp_standard_deviation real,
    bp_chi_squared real,
    bp_coefficients double precision[],
    bp_coefficient_errors real[],
    bp_coefficient_correlations real[],
    bp_n_relevant_bases smallint,
    bp_relative_shrinking real,
    rp_basis_function_id smallint,
    rp_degrees_of_freedom smallint,
    rp_n_parameters smallint,
    rp_n_measurements smallint,
    rp_n_rejected_measurements smallint,
    rp_standard_deviation real,
    rp_chi_squared real,
    rp_coefficients double precision[],
    rp_coefficient_errors real[],
    rp_coefficient_correlations real[],
    rp_n_relevant_bases smallint,
    rp_relative_shrinking real
);
COMMENT ON TABLE gaiadr3.xp_continuous_mean_spectrum IS 'Table hosting the mean BP and RP spectra based on the continuous representation in basis functions (see~\secref{cu5pho_ssec:meanSpecGen}). Note this table is not available through the main archive TAP interface. Data are delivered via the Massive Data service indexed by the VO Datalink protocol and described in Chapter~\ref{chap:archive}. For example this can be actioned in the archive user interface by querying the main source catalogue {\tt GaiaSource} and selecting {\tt hasXpContinuous}~{\tt = ''t''}.';
COMMENT ON COLUMN gaiadr3.xp_continuous_mean_spectrum.source_id IS 'Unique source identifier (unique within a particular Data Release)';
COMMENT ON COLUMN gaiadr3.xp_continuous_mean_spectrum.solution_id IS 'Solution Identifier';
COMMENT ON COLUMN gaiadr3.xp_continuous_mean_spectrum.bp_basis_function_id IS 'Identifier defining the set of basis functions for the BP spectrum representation';
COMMENT ON COLUMN gaiadr3.xp_continuous_mean_spectrum.bp_degrees_of_freedom IS 'Degrees of freedom for the BP spectrum representation';
COMMENT ON COLUMN gaiadr3.xp_continuous_mean_spectrum.bp_n_parameters IS 'Number of parameters for the BP spectrum representation';
COMMENT ON COLUMN gaiadr3.xp_continuous_mean_spectrum.bp_n_measurements IS 'Number of measurements used for the BP spectrum generation';
COMMENT ON COLUMN gaiadr3.xp_continuous_mean_spectrum.bp_n_rejected_measurements IS 'Number of rejected measurements in the BP spectrum generation';
COMMENT ON COLUMN gaiadr3.xp_continuous_mean_spectrum.bp_standard_deviation IS 'Standard deviation for the BP spectrum representation';
COMMENT ON COLUMN gaiadr3.xp_continuous_mean_spectrum.bp_chi_squared IS 'Chi squared for the BP spectrum representation';
COMMENT ON COLUMN gaiadr3.xp_continuous_mean_spectrum.bp_coefficients IS 'Basis function coefficients for the BP spectrum representation';
COMMENT ON COLUMN gaiadr3.xp_continuous_mean_spectrum.bp_coefficient_errors IS 'Basis function coefficient errors for the BP spectrum representation';
COMMENT ON COLUMN gaiadr3.xp_continuous_mean_spectrum.bp_coefficient_correlations IS 'Correlation matrix for BP coefficients';
COMMENT ON COLUMN gaiadr3.xp_continuous_mean_spectrum.bp_n_relevant_bases IS 'Number of bases that are relevant for the representation of this mean BP spectrum';
COMMENT ON COLUMN gaiadr3.xp_continuous_mean_spectrum.bp_relative_shrinking IS 'Measure of the relative shrinking of the coefficient vector when truncation is applied for the mean BP spectrum';
COMMENT ON COLUMN gaiadr3.xp_continuous_mean_spectrum.rp_basis_function_id IS 'Identifier defining the set of basis functions for the RP spectrum representation';
COMMENT ON COLUMN gaiadr3.xp_continuous_mean_spectrum.rp_degrees_of_freedom IS 'Degrees of freedom for the RP spectrum representation';
COMMENT ON COLUMN gaiadr3.xp_continuous_mean_spectrum.rp_n_parameters IS 'Number of parameters for the RP spectrum representation';
COMMENT ON COLUMN gaiadr3.xp_continuous_mean_spectrum.rp_n_measurements IS 'Number of measurements used for the RP spectrum generation';
COMMENT ON COLUMN gaiadr3.xp_continuous_mean_spectrum.rp_n_rejected_measurements IS 'Number of rejected measurements in the RP spectrum generation';
COMMENT ON COLUMN gaiadr3.xp_continuous_mean_spectrum.rp_standard_deviation IS 'Standard deviation for the RP spectrum representation';
COMMENT ON COLUMN gaiadr3.xp_continuous_mean_spectrum.rp_chi_squared IS 'Chi squared for the RP spectrum representation';
COMMENT ON COLUMN gaiadr3.xp_continuous_mean_spectrum.rp_coefficients IS 'Basis function coefficients for the RP spectrum representation';
COMMENT ON COLUMN gaiadr3.xp_continuous_mean_spectrum.rp_coefficient_errors IS 'Basis function coefficient errors for the RP spectrum representation';
COMMENT ON COLUMN gaiadr3.xp_continuous_mean_spectrum.rp_coefficient_correlations IS 'Correlation matrix for RP coefficients';
COMMENT ON COLUMN gaiadr3.xp_continuous_mean_spectrum.rp_n_relevant_bases IS 'Number of bases that are relevant for the representation of this mean RP spectrum';
COMMENT ON COLUMN gaiadr3.xp_continuous_mean_spectrum.rp_relative_shrinking IS 'Measure of the relative shrinking of the coefficient vector when truncation is applied for the mean RP spectrum';
CREATE INDEX IF NOT EXISTS gaiadr3_xp_continuous_mean_spectrum_source_id_idx ON gaiadr3.xp_continuous_mean_spectrum (source_id);

-- [Espectroscopía] gaiadr3.xp_sampled_mean_spectrum — acceso: DataLink (XP_SAMPLED)
CREATE TABLE IF NOT EXISTS gaiadr3.xp_sampled_mean_spectrum (
    source_id bigint,
    solution_id bigint,
    ra double precision,
    dec double precision,
    flux real[],
    flux_error real[]
);
COMMENT ON TABLE gaiadr3.xp_sampled_mean_spectrum IS 'This is the BP/RP externally calibrated sampled mean spectrum. All mean spectra are sampled to the same set of absolute wavelength positions, viz.~343 values from 336~to 1020~nm with a step of 2~nm. Note this table is not available through the main archive TAP interface. Data are delivered via the Massive Data service indexed by the VO Datalink protocol and described in Chapter~\ref{chap:archive}. For example this can be actioned in the archive user interface by querying the main source catalogue {\tt GaiaSource} and selecting {\tt hasXpSampled}~{\tt = ''t''}.';
COMMENT ON COLUMN gaiadr3.xp_sampled_mean_spectrum.source_id IS 'Unique source identifier (unique within a particular Data Release)';
COMMENT ON COLUMN gaiadr3.xp_sampled_mean_spectrum.solution_id IS 'Solution Identifier';
COMMENT ON COLUMN gaiadr3.xp_sampled_mean_spectrum.ra IS 'Right Ascension [deg]';
COMMENT ON COLUMN gaiadr3.xp_sampled_mean_spectrum.dec IS 'Declination [deg]';
COMMENT ON COLUMN gaiadr3.xp_sampled_mean_spectrum.flux IS 'mean BP + RP combined spectrum flux [W.m**-2.nm**-1]';
COMMENT ON COLUMN gaiadr3.xp_sampled_mean_spectrum.flux_error IS 'mean BP + RP combined spectrum flux error [W.m**-2.nm**-1]';
CREATE INDEX IF NOT EXISTS gaiadr3_xp_sampled_mean_spectrum_source_id_idx ON gaiadr3.xp_sampled_mean_spectrum (source_id);

-- [Espectroscopía] gaiadr3.xp_summary — acceso: TAP Gaia (ADQL)
CREATE TABLE IF NOT EXISTS gaiadr3.xp_summary (
    source_id bigint,
    solution_id bigint,
    bp_n_relevant_bases smallint,
    bp_relative_shrinking real,
    bp_n_measurements smallint,
    bp_n_rejected_measurements smallint,
    bp_standard_deviation real,
    bp_chi_squared real,
    bp_n_transits smallint,
    bp_n_contaminated_transits smallint,
    bp_n_blended_transits smallint,
    rp_n_relevant_bases smallint,
    rp_relative_shrinking real,
    rp_n_measurements smallint,
    rp_n_rejected_measurements smallint,
    rp_standard_deviation real,
    rp_chi_squared real,
    rp_n_transits smallint,
    rp_n_contaminated_transits smallint,
    rp_n_blended_transits smallint
);
COMMENT ON TABLE gaiadr3.xp_summary IS 'This tables contains auxiliary information about the mean BP/RP spectrum of a given source. It should be used in order to refine queries on spectra and build dedicated samples before interrogating the DataLink protocol to download the results of those queries.';
COMMENT ON COLUMN gaiadr3.xp_summary.source_id IS 'Unique source identifier (unique within a particular Data Release)';
COMMENT ON COLUMN gaiadr3.xp_summary.solution_id IS 'Solution Identifier';
COMMENT ON COLUMN gaiadr3.xp_summary.bp_n_relevant_bases IS 'Number of bases that are relevant for the representation of this mean BP spectrum';
COMMENT ON COLUMN gaiadr3.xp_summary.bp_relative_shrinking IS 'Measure of the relative shrinking of the coefficient vector when truncation is applied for the mean BP spectrum';
COMMENT ON COLUMN gaiadr3.xp_summary.bp_n_measurements IS 'Number of measurements used for the BP spectrum generation';
COMMENT ON COLUMN gaiadr3.xp_summary.bp_n_rejected_measurements IS 'Number of rejected measurements in the BP spectrum generation';
COMMENT ON COLUMN gaiadr3.xp_summary.bp_standard_deviation IS 'Standard deviation for the BP spectrum representation [''electron''.s**-1.pixel**-1]';
COMMENT ON COLUMN gaiadr3.xp_summary.bp_chi_squared IS 'Chi squared for the BP spectrum representation';
COMMENT ON COLUMN gaiadr3.xp_summary.bp_n_transits IS 'Number of transits contributing to the mean in BP';
COMMENT ON COLUMN gaiadr3.xp_summary.bp_n_contaminated_transits IS 'Number of contaminated transits in BP';
COMMENT ON COLUMN gaiadr3.xp_summary.bp_n_blended_transits IS 'Number of blended transits in BP';
COMMENT ON COLUMN gaiadr3.xp_summary.rp_n_relevant_bases IS 'Number of bases that are relevant for the representation of this mean RP spectrum';
COMMENT ON COLUMN gaiadr3.xp_summary.rp_relative_shrinking IS 'Measure of the relative shrinking of the coefficient vector when truncation is applied for the mean RP spectrum';
COMMENT ON COLUMN gaiadr3.xp_summary.rp_n_measurements IS 'Number of measurements used for the RP spectrum generation';
COMMENT ON COLUMN gaiadr3.xp_summary.rp_n_rejected_measurements IS 'Number of rejected measurements in the RP spectrum generation';
COMMENT ON COLUMN gaiadr3.xp_summary.rp_standard_deviation IS 'Standard deviation for the RP spectrum representation [''electron''.s**-1.pixel**-1]';
COMMENT ON COLUMN gaiadr3.xp_summary.rp_chi_squared IS 'Chi squared for the RP spectrum representation';
COMMENT ON COLUMN gaiadr3.xp_summary.rp_n_transits IS 'Number of transits contributing to the mean in RP';
COMMENT ON COLUMN gaiadr3.xp_summary.rp_n_contaminated_transits IS 'Number of contaminated transits in RP';
COMMENT ON COLUMN gaiadr3.xp_summary.rp_n_blended_transits IS 'Number of blended transits in RP';
CREATE INDEX IF NOT EXISTS gaiadr3_xp_summary_source_id_idx ON gaiadr3.xp_summary (source_id);

-- [Variabilidad] gaiadr3.vari_agn — acceso: TAP Gaia (ADQL)
CREATE TABLE IF NOT EXISTS gaiadr3.vari_agn (
    solution_id bigint,
    source_id bigint,
    fractional_variability_g real,
    structure_function_index real,
    structure_function_index_scatter real,
    qso_variability real,
    non_qso_variability real
);
COMMENT ON TABLE gaiadr3.vari_agn IS 'This table provides information on AGN properties.';
COMMENT ON COLUMN gaiadr3.vari_agn.solution_id IS 'Solution Identifier';
COMMENT ON COLUMN gaiadr3.vari_agn.source_id IS 'Unique source identifier';
COMMENT ON COLUMN gaiadr3.vari_agn.fractional_variability_g IS 'Fractional variability in the G band';
COMMENT ON COLUMN gaiadr3.vari_agn.structure_function_index IS 'Index of the first-order structure function in the G band';
COMMENT ON COLUMN gaiadr3.vari_agn.structure_function_index_scatter IS 'Standard deviation of the index of the structure function';
COMMENT ON COLUMN gaiadr3.vari_agn.qso_variability IS 'Quasar variability metric in the G band';
COMMENT ON COLUMN gaiadr3.vari_agn.non_qso_variability IS 'Non-quasar variability metric in the G band';
CREATE INDEX IF NOT EXISTS gaiadr3_vari_agn_source_id_idx ON gaiadr3.vari_agn (source_id);

-- [Variabilidad] gaiadr3.vari_cepheid — acceso: TAP Gaia (ADQL)
CREATE TABLE IF NOT EXISTS gaiadr3.vari_cepheid (
    solution_id bigint,
    source_id bigint,
    pf double precision,
    pf_error real,
    p1_o double precision,
    p1_o_error real,
    epoch_g double precision,
    epoch_g_error real,
    epoch_bp double precision,
    epoch_bp_error real,
    epoch_rp double precision,
    epoch_rp_error real,
    epoch_rv double precision,
    epoch_rv_error real,
    int_average_g real,
    int_average_g_error real,
    int_average_bp real,
    int_average_bp_error real,
    int_average_rp real,
    int_average_rp_error real,
    average_rv real,
    average_rv_error real,
    peak_to_peak_g real,
    peak_to_peak_g_error real,
    peak_to_peak_bp real,
    peak_to_peak_bp_error real,
    peak_to_peak_rp real,
    peak_to_peak_rp_error real,
    peak_to_peak_rv double precision,
    peak_to_peak_rv_error double precision,
    metallicity real,
    metallicity_error real,
    r21_g real,
    r21_g_error real,
    r31_g real,
    r31_g_error real,
    phi21_g real,
    phi21_g_error real,
    phi31_g real,
    phi31_g_error real,
    num_clean_epochs_g smallint,
    num_clean_epochs_bp smallint,
    num_clean_epochs_rp smallint,
    num_clean_epochs_rv smallint,
    zp_mag_g real,
    zp_mag_bp real,
    zp_mag_rp real,
    num_harmonics_for_p1_g smallint,
    num_harmonics_for_p1_bp smallint,
    num_harmonics_for_p1_rp smallint,
    num_harmonics_for_p1_rv smallint,
    reference_time_g double precision,
    reference_time_bp double precision,
    reference_time_rp double precision,
    reference_time_rv double precision,
    fund_freq1 double precision,
    fund_freq1_error real,
    fund_freq2 double precision,
    fund_freq2_error real,
    fund_freq1_harmonic_ampl_g real[],
    fund_freq1_harmonic_ampl_g_error real[],
    fund_freq1_harmonic_phase_g real[],
    fund_freq1_harmonic_phase_g_error real[],
    fund_freq1_harmonic_ampl_bp real[],
    fund_freq1_harmonic_ampl_bp_error real[],
    fund_freq1_harmonic_phase_bp real[],
    fund_freq1_harmonic_phase_bp_error real[],
    fund_freq1_harmonic_ampl_rp real[],
    fund_freq1_harmonic_ampl_rp_error real[],
    fund_freq1_harmonic_phase_rp real[],
    fund_freq1_harmonic_phase_rp_error real[],
    fund_freq1_harmonic_ampl_rv real[],
    fund_freq1_harmonic_ampl_rv_error real[],
    fund_freq1_harmonic_phase_rv real[],
    fund_freq1_harmonic_phase_rv_error real[],
    p2_o double precision,
    p2_o_error real,
    type_best_classification text,
    type2_best_sub_classification text,
    mode_best_classification text,
    multi_mode_best_classification text
);
COMMENT ON TABLE gaiadr3.vari_cepheid IS 'This table describes the Cepheid stars.';
COMMENT ON COLUMN gaiadr3.vari_cepheid.solution_id IS 'Solution Identifier';
COMMENT ON COLUMN gaiadr3.vari_cepheid.source_id IS 'Unique source identifier';
COMMENT ON COLUMN gaiadr3.vari_cepheid.pf IS 'Period corresponding to the fundamental pulsation mode in the G band time series [d]';
COMMENT ON COLUMN gaiadr3.vari_cepheid.pf_error IS 'Uncertainty of the \texttt{pf} period [d]';
COMMENT ON COLUMN gaiadr3.vari_cepheid.p1_o IS 'Period corresponding to the first overtone pulsation mode in the G band time series [d]';
COMMENT ON COLUMN gaiadr3.vari_cepheid.p1_o_error IS 'Uncertainty of the \texttt{p1O} period [d]';
COMMENT ON COLUMN gaiadr3.vari_cepheid.epoch_g IS 'Epoch of the maximum of the light curve in the G band [d]';
COMMENT ON COLUMN gaiadr3.vari_cepheid.epoch_g_error IS 'Uncertainty on the epoch parameter \texttt{epochG} [d]';
COMMENT ON COLUMN gaiadr3.vari_cepheid.epoch_bp IS 'Epoch of the maximum of the light curve in the BP band [d]';
COMMENT ON COLUMN gaiadr3.vari_cepheid.epoch_bp_error IS 'Uncertainty on the epoch parameter \texttt{epochBp} [d]';
COMMENT ON COLUMN gaiadr3.vari_cepheid.epoch_rp IS 'Epoch of the maximum of the light curve in the RP band [d]';
COMMENT ON COLUMN gaiadr3.vari_cepheid.epoch_rp_error IS 'Uncertainty on the epoch parameter \texttt{epochRp} [d]';
COMMENT ON COLUMN gaiadr3.vari_cepheid.epoch_rv IS 'Epoch of the minimum of the radial velocity curve [d]';
COMMENT ON COLUMN gaiadr3.vari_cepheid.epoch_rv_error IS 'Uncertainty on the epoch parameter \texttt{epochRv} [d]';
COMMENT ON COLUMN gaiadr3.vari_cepheid.int_average_g IS 'Intensity-averaged magnitude in the G band [mag]';
COMMENT ON COLUMN gaiadr3.vari_cepheid.int_average_g_error IS 'Uncertainty on \texttt{intAverageG} parameter [mag]';
COMMENT ON COLUMN gaiadr3.vari_cepheid.int_average_bp IS 'Intensity-averaged magnitude in the BP band [mag]';
COMMENT ON COLUMN gaiadr3.vari_cepheid.int_average_bp_error IS 'Uncertainty on \texttt{intAverageBp} parameter [mag]';
COMMENT ON COLUMN gaiadr3.vari_cepheid.int_average_rp IS 'Intensity-averaged magnitude in the RP band [mag]';
COMMENT ON COLUMN gaiadr3.vari_cepheid.int_average_rp_error IS 'Uncertainty on \texttt{intAverageRp} parameter [mag]';
COMMENT ON COLUMN gaiadr3.vari_cepheid.average_rv IS 'Mean radial velocity [km.s**-1]';
COMMENT ON COLUMN gaiadr3.vari_cepheid.average_rv_error IS 'Uncertainty on \texttt{averageRv} parameter [km.s**-1]';
COMMENT ON COLUMN gaiadr3.vari_cepheid.peak_to_peak_g IS 'Peak-to-peak amplitude of the G band light curve [mag]';
COMMENT ON COLUMN gaiadr3.vari_cepheid.peak_to_peak_g_error IS 'Uncertainty on the \texttt{peakToPeakG} parameter [mag]';
COMMENT ON COLUMN gaiadr3.vari_cepheid.peak_to_peak_bp IS 'Peak-to-peak amplitude of the BP band light curve [mag]';
COMMENT ON COLUMN gaiadr3.vari_cepheid.peak_to_peak_bp_error IS 'Uncertainty on the \texttt{peakToPeakBp} parameter [mag]';
COMMENT ON COLUMN gaiadr3.vari_cepheid.peak_to_peak_rp IS 'Peak-to-peak amplitude of the RP band light curve [mag]';
COMMENT ON COLUMN gaiadr3.vari_cepheid.peak_to_peak_rp_error IS 'Uncertainty on the \texttt{peakToPeakRp} parameter [mag]';
COMMENT ON COLUMN gaiadr3.vari_cepheid.peak_to_peak_rv IS 'Peak-to-peak amplitude of the radial velocity curve [km.s**-1]';
COMMENT ON COLUMN gaiadr3.vari_cepheid.peak_to_peak_rv_error IS 'Uncertainty on the \texttt{peakToPeakRv} parameter [km.s**-1]';
COMMENT ON COLUMN gaiadr3.vari_cepheid.metallicity IS 'Metallicity of the star from the Fourier parameters of the light curve [''dex'']';
COMMENT ON COLUMN gaiadr3.vari_cepheid.metallicity_error IS 'Uncertainty of the \texttt{metallicity} parameter [''dex'']';
COMMENT ON COLUMN gaiadr3.vari_cepheid.r21_g IS 'Fourier decomposition parameter \texttt{r21G}: A2/A1 (for G band)';
COMMENT ON COLUMN gaiadr3.vari_cepheid.r21_g_error IS 'Uncertainty on the \texttt{r21G} parameter: A2/A1 (for G band)';
COMMENT ON COLUMN gaiadr3.vari_cepheid.r31_g IS 'Fourier decomposition parameter \texttt{r31G}: A3/A1 (for G band)';
COMMENT ON COLUMN gaiadr3.vari_cepheid.r31_g_error IS 'Uncertainty on the \texttt{r31G} parameter: A3/A1 (for G band)';
COMMENT ON COLUMN gaiadr3.vari_cepheid.phi21_g IS 'Fourier decomposition parameter \texttt{phi21G}: phi2 - 2*phi1 (for G band) [rad]';
COMMENT ON COLUMN gaiadr3.vari_cepheid.phi21_g_error IS 'Uncertainty on the \texttt{phi21G} parameter: phi2 - 2*phi1 (for G band) [rad]';
COMMENT ON COLUMN gaiadr3.vari_cepheid.phi31_g IS 'Fourier decomposition parameter \texttt{phi31G}: phi3 - 3*phi1 (for G band) [rad]';
COMMENT ON COLUMN gaiadr3.vari_cepheid.phi31_g_error IS 'Uncertainty on the \texttt{phi31G} parameter: phi3 - 3*phi1 (for G band) [rad]';
COMMENT ON COLUMN gaiadr3.vari_cepheid.num_clean_epochs_g IS 'Number of G FoV epochs used in the fitting algorithm';
COMMENT ON COLUMN gaiadr3.vari_cepheid.num_clean_epochs_bp IS 'Number of BP epochs used in the fitting algorithm';
COMMENT ON COLUMN gaiadr3.vari_cepheid.num_clean_epochs_rp IS 'Number of RP epochs used in the fitting algorithm';
COMMENT ON COLUMN gaiadr3.vari_cepheid.num_clean_epochs_rv IS 'Number of radial velocity epochs used in the fitting algorithm';
COMMENT ON COLUMN gaiadr3.vari_cepheid.zp_mag_g IS 'Zero point (mag) of the final model of the G band light curve [mag]';
COMMENT ON COLUMN gaiadr3.vari_cepheid.zp_mag_bp IS 'Zero point (mag) of the final model of the BP band light curve [mag]';
COMMENT ON COLUMN gaiadr3.vari_cepheid.zp_mag_rp IS 'Zero point (mag) of the final model of the RP band light curve [mag]';
COMMENT ON COLUMN gaiadr3.vari_cepheid.num_harmonics_for_p1_g IS 'Number of harmonics used to model the first periodicity of the G-band light curve';
COMMENT ON COLUMN gaiadr3.vari_cepheid.num_harmonics_for_p1_bp IS 'Number of harmonics used to model the first periodicity of the BP-band light curve';
COMMENT ON COLUMN gaiadr3.vari_cepheid.num_harmonics_for_p1_rp IS 'Number of harmonics used to model the first periodicity of the RP-band light curve';
COMMENT ON COLUMN gaiadr3.vari_cepheid.num_harmonics_for_p1_rv IS 'Number of harmonics used to model the first periodicity of the radial velocity curve';
COMMENT ON COLUMN gaiadr3.vari_cepheid.reference_time_g IS 'Reference time of the Fourier modelled G-band light curve [d]';
COMMENT ON COLUMN gaiadr3.vari_cepheid.reference_time_bp IS 'Reference time of the Fourier modelled BP-band light curve [d]';
COMMENT ON COLUMN gaiadr3.vari_cepheid.reference_time_rp IS 'Reference time of the Fourier modelled RP-band light curve [d]';
COMMENT ON COLUMN gaiadr3.vari_cepheid.reference_time_rv IS 'Reference time of the Fourier modelled radial velocity curve [d]';
COMMENT ON COLUMN gaiadr3.vari_cepheid.fund_freq1 IS 'First frequency of the non-linear Fourier modelling [d**-1]';
COMMENT ON COLUMN gaiadr3.vari_cepheid.fund_freq1_error IS 'Error of the first frequency of the non-linear Fourier modelling [d**-1]';
COMMENT ON COLUMN gaiadr3.vari_cepheid.fund_freq2 IS 'Second frequency of the non-linear Fourier modelling in the G band [d**-1]';
COMMENT ON COLUMN gaiadr3.vari_cepheid.fund_freq2_error IS 'Error of the second frequency of the non-linear Fourier modelling in the G band [d**-1]';
COMMENT ON COLUMN gaiadr3.vari_cepheid.fund_freq1_harmonic_ampl_g IS 'Amplitudes of the Fourier model for the first frequency in the G band [mag]';
COMMENT ON COLUMN gaiadr3.vari_cepheid.fund_freq1_harmonic_ampl_g_error IS 'Errors of the amplitudes of the Fourier model for the first frequency in the G band [mag]';
COMMENT ON COLUMN gaiadr3.vari_cepheid.fund_freq1_harmonic_phase_g IS 'Phases of the Fourier model for the first frequency in the G band [rad]';
COMMENT ON COLUMN gaiadr3.vari_cepheid.fund_freq1_harmonic_phase_g_error IS 'Errors of the phases of the Fourier model for the first frequency in the G band [rad]';
COMMENT ON COLUMN gaiadr3.vari_cepheid.fund_freq1_harmonic_ampl_bp IS 'Amplitudes of the Fourier model for the first frequency in the BP band [mag]';
COMMENT ON COLUMN gaiadr3.vari_cepheid.fund_freq1_harmonic_ampl_bp_error IS 'Errors of the amplitudes of the Fourier model for the first frequency in the BP band [mag]';
COMMENT ON COLUMN gaiadr3.vari_cepheid.fund_freq1_harmonic_phase_bp IS 'Phases of the Fourier model for the first frequency in the BP band [rad]';
COMMENT ON COLUMN gaiadr3.vari_cepheid.fund_freq1_harmonic_phase_bp_error IS 'Errors of the phases of the Fourier model for the first frequency in the BP band [rad]';
COMMENT ON COLUMN gaiadr3.vari_cepheid.fund_freq1_harmonic_ampl_rp IS 'Amplitudes of the Fourier model for the first frequency in the RP band [mag]';
COMMENT ON COLUMN gaiadr3.vari_cepheid.fund_freq1_harmonic_ampl_rp_error IS 'Errors of the amplitudes of the Fourier model for the first frequency in the RP band [mag]';
COMMENT ON COLUMN gaiadr3.vari_cepheid.fund_freq1_harmonic_phase_rp IS 'Phases of the Fourier model for the first frequency in the RP band [rad]';
COMMENT ON COLUMN gaiadr3.vari_cepheid.fund_freq1_harmonic_phase_rp_error IS 'Errors of the phases of the Fourier model for the first frequency in the RP band [rad]';
COMMENT ON COLUMN gaiadr3.vari_cepheid.fund_freq1_harmonic_ampl_rv IS 'Amplitudes of the Fourier model for the first frequency of the radial velocity curve [km.s**-1]';
COMMENT ON COLUMN gaiadr3.vari_cepheid.fund_freq1_harmonic_ampl_rv_error IS 'Errors of the amplitudes of the Fourier model for the first frequency of the radial velocity curve [km.s**-1]';
COMMENT ON COLUMN gaiadr3.vari_cepheid.fund_freq1_harmonic_phase_rv IS 'Phases of the Fourier model for the first frequency of the radial velocity curve [rad]';
COMMENT ON COLUMN gaiadr3.vari_cepheid.fund_freq1_harmonic_phase_rv_error IS 'Errors of the phases of the Fourier model for the first frequency of the radial velocity curve [rad]';
COMMENT ON COLUMN gaiadr3.vari_cepheid.p2_o IS 'Period corresponding to the second overtone pulsation mode (for multi mode pulsators) in the G band time series [d]';
COMMENT ON COLUMN gaiadr3.vari_cepheid.p2_o_error IS 'Uncertainty of the p2O period [d]';
COMMENT ON COLUMN gaiadr3.vari_cepheid.type_best_classification IS 'Best type classification estimate out of: `DCEP, `T2CEP, `ACEP';
COMMENT ON COLUMN gaiadr3.vari_cepheid.type2_best_sub_classification IS 'Best subclassification estimate for typeBestClassification=`T2CEP out of: `BL_HER, `W_VIR,`RV_TAU';
COMMENT ON COLUMN gaiadr3.vari_cepheid.mode_best_classification IS 'Best mode classification estimate out of: `FUNDAMENTAL, `FIRST_OVERTONE, `SECOND_OVERTONE, `MULTI,`UNDEFINED, `NOT_APPLICABLE';
COMMENT ON COLUMN gaiadr3.vari_cepheid.multi_mode_best_classification IS 'Best multi mode DCEP classification out of: `F/1O, `F/2O, `1O/2O, `1O/3O, `2O/3O, `F/1O/2O, `1O/2O/3O';
CREATE INDEX IF NOT EXISTS gaiadr3_vari_cepheid_source_id_idx ON gaiadr3.vari_cepheid (source_id);

-- [Variabilidad] gaiadr3.vari_classifier_class_definition — acceso: TAP Gaia (ADQL)
CREATE TABLE IF NOT EXISTS gaiadr3.vari_classifier_class_definition (
    solution_id bigint,
    classifier_name text,
    class_name text,
    class_description text
);
COMMENT ON TABLE gaiadr3.vari_classifier_class_definition IS 'Table with detailed descriptions of published classes for each classifier described in {\tt VariClassifierDefinition} and used in table {\tt VariClassifierResult}. In DR3, this table contains the details of a classifier with {\tt classifierName}=`nTransits:5+.';
COMMENT ON COLUMN gaiadr3.vari_classifier_class_definition.solution_id IS 'Solution Identifier';
COMMENT ON COLUMN gaiadr3.vari_classifier_class_definition.classifier_name IS 'Name of the classifier that is detailed in this entry';
COMMENT ON COLUMN gaiadr3.vari_classifier_class_definition.class_name IS 'Name of the published class from this classifier';
COMMENT ON COLUMN gaiadr3.vari_classifier_class_definition.class_description IS 'Description of the published class from this classifier';

-- [Variabilidad] gaiadr3.vari_classifier_definition — acceso: TAP Gaia (ADQL)
CREATE TABLE IF NOT EXISTS gaiadr3.vari_classifier_definition (
    solution_id bigint,
    classifier_name text,
    classifier_description text
);
COMMENT ON TABLE gaiadr3.vari_classifier_definition IS 'Table with detailed descriptions of all classifiers used in table {\tt VariClassifierResult}. Details of the published classes for each classifier can be found in {\tt VariClassifierClassDefinition}. In DR3, this table contains the details of a classifier with {\tt classifierName}=`nTransits:5+.';
COMMENT ON COLUMN gaiadr3.vari_classifier_definition.solution_id IS 'Solution Identifier';
COMMENT ON COLUMN gaiadr3.vari_classifier_definition.classifier_name IS 'Name of the classifier that is detailed in this entry';
COMMENT ON COLUMN gaiadr3.vari_classifier_definition.classifier_description IS 'Description of this classifier';

-- [Variabilidad] gaiadr3.vari_classifier_result — acceso: TAP Gaia (ADQL)
CREATE TABLE IF NOT EXISTS gaiadr3.vari_classifier_result (
    solution_id bigint,
    source_id bigint,
    classifier_name text,
    best_class_name text,
    best_class_score real
);
COMMENT ON TABLE gaiadr3.vari_classifier_result IS 'Table with variability classification results of all classifiers, which are identified by the {\tt classifierName} column. In DR3, multiple classifiers (depending on class) are combined into a single classifier with {\tt classifierName}=`nTransits:5+, which is described in {\tt VariClassifierDefinition} and identifies the classes defined in {\tt VariClassifierClassDefinition}.';
COMMENT ON COLUMN gaiadr3.vari_classifier_result.solution_id IS 'Solution Identifier';
COMMENT ON COLUMN gaiadr3.vari_classifier_result.source_id IS 'Unique source identifier';
COMMENT ON COLUMN gaiadr3.vari_classifier_result.classifier_name IS 'Classifier name used to produce this result, use for lookup in \texttt{VariClassifierDefinition} table';
COMMENT ON COLUMN gaiadr3.vari_classifier_result.best_class_name IS 'Name of best class, see table \texttt{VariClassifierClassDefinition} for details of the class';
COMMENT ON COLUMN gaiadr3.vari_classifier_result.best_class_score IS 'Score of the best class';
CREATE INDEX IF NOT EXISTS gaiadr3_vari_classifier_result_source_id_idx ON gaiadr3.vari_classifier_result (source_id);

-- [Variabilidad] gaiadr3.vari_compact_companion — acceso: TAP Gaia (ADQL)
CREATE TABLE IF NOT EXISTS gaiadr3.vari_compact_companion (
    solution_id bigint,
    source_id bigint,
    period double precision,
    period_error real,
    t0_g double precision,
    t0_g_error real,
    t0_bp double precision,
    t0_bp_error real,
    t0_rp double precision,
    t0_rp_error real,
    harmonic_model_params_g real[],
    harmonic_model_params_g_error real[],
    harmonic_model_params_bp real[],
    harmonic_model_params_bp_error real[],
    harmonic_model_params_rp real[],
    harmonic_model_params_rp_error real[],
    model_mean_g real,
    model_mean_g_error real,
    model_mean_bp real,
    model_mean_bp_error real,
    model_mean_rp real,
    model_mean_rp_error real,
    mod_min_mass_ratio real,
    mod_min_mass_ratio_one_sigma real,
    mod_min_mass_ratio_three_sigma real,
    alpha real
);
COMMENT ON TABLE gaiadr3.vari_compact_companion IS 'This table describes the compact companion candidates.';
COMMENT ON COLUMN gaiadr3.vari_compact_companion.solution_id IS 'Solution Identifier';
COMMENT ON COLUMN gaiadr3.vari_compact_companion.source_id IS 'Unique source identifier';
COMMENT ON COLUMN gaiadr3.vari_compact_companion.period IS 'Orbital period [d]';
COMMENT ON COLUMN gaiadr3.vari_compact_companion.period_error IS 'Orbital period error [d]';
COMMENT ON COLUMN gaiadr3.vari_compact_companion.t0_g IS 'G-band reference time [d]';
COMMENT ON COLUMN gaiadr3.vari_compact_companion.t0_g_error IS 'G-band reference time error [d]';
COMMENT ON COLUMN gaiadr3.vari_compact_companion.t0_bp IS 'BP-band reference time [d]';
COMMENT ON COLUMN gaiadr3.vari_compact_companion.t0_bp_error IS 'BP-band reference time error [d]';
COMMENT ON COLUMN gaiadr3.vari_compact_companion.t0_rp IS 'RP-band reference time [d]';
COMMENT ON COLUMN gaiadr3.vari_compact_companion.t0_rp_error IS 'RP-band reference time error [d]';
COMMENT ON COLUMN gaiadr3.vari_compact_companion.harmonic_model_params_g IS 'G-band harmonics [mag]';
COMMENT ON COLUMN gaiadr3.vari_compact_companion.harmonic_model_params_g_error IS 'G-band harmonics errors [mag]';
COMMENT ON COLUMN gaiadr3.vari_compact_companion.harmonic_model_params_bp IS 'BP-band harmonics [mag]';
COMMENT ON COLUMN gaiadr3.vari_compact_companion.harmonic_model_params_bp_error IS 'BP-band harmonics errors [mag]';
COMMENT ON COLUMN gaiadr3.vari_compact_companion.harmonic_model_params_rp IS 'RP-band harmonics [mag]';
COMMENT ON COLUMN gaiadr3.vari_compact_companion.harmonic_model_params_rp_error IS 'RP-band harmonics errors [mag]';
COMMENT ON COLUMN gaiadr3.vari_compact_companion.model_mean_g IS 'Harmonics model mean G-band magnitude [mag]';
COMMENT ON COLUMN gaiadr3.vari_compact_companion.model_mean_g_error IS 'Harmonics model mean G-band magnitude error [mag]';
COMMENT ON COLUMN gaiadr3.vari_compact_companion.model_mean_bp IS 'Harmonics model mean BP-band magnitude [mag]';
COMMENT ON COLUMN gaiadr3.vari_compact_companion.model_mean_bp_error IS 'Harmonics model mean BP-band magnitude error [mag]';
COMMENT ON COLUMN gaiadr3.vari_compact_companion.model_mean_rp IS 'Harmonics model mean RP-band magnitude [mag]';
COMMENT ON COLUMN gaiadr3.vari_compact_companion.model_mean_rp_error IS 'Harmonics model mean RP-band magnitude error [mag]';
COMMENT ON COLUMN gaiadr3.vari_compact_companion.mod_min_mass_ratio IS 'Modified minimum mass ratio';
COMMENT ON COLUMN gaiadr3.vari_compact_companion.mod_min_mass_ratio_one_sigma IS '15.9 percentile modified minimum mass ratio';
COMMENT ON COLUMN gaiadr3.vari_compact_companion.mod_min_mass_ratio_three_sigma IS '0.135 percentile modified minimum mass ratio';
COMMENT ON COLUMN gaiadr3.vari_compact_companion.alpha IS 'alpha ellipsoidal coefficient';
CREATE INDEX IF NOT EXISTS gaiadr3_vari_compact_companion_source_id_idx ON gaiadr3.vari_compact_companion (source_id);

-- [Variabilidad] gaiadr3.vari_eclipsing_binary — acceso: TAP Gaia (ADQL)
CREATE TABLE IF NOT EXISTS gaiadr3.vari_eclipsing_binary (
    solution_id bigint,
    source_id bigint,
    global_ranking real,
    reference_time double precision,
    frequency double precision,
    frequency_error real,
    geom_model_reference_level real,
    geom_model_reference_level_error real,
    geom_model_gaussian1_phase real,
    geom_model_gaussian1_phase_error real,
    geom_model_gaussian1_sigma real,
    geom_model_gaussian1_sigma_error real,
    geom_model_gaussian1_depth real,
    geom_model_gaussian1_depth_error real,
    geom_model_gaussian2_phase real,
    geom_model_gaussian2_phase_error real,
    geom_model_gaussian2_sigma real,
    geom_model_gaussian2_sigma_error real,
    geom_model_gaussian2_depth real,
    geom_model_gaussian2_depth_error real,
    geom_model_cosine_half_period_amplitude real,
    geom_model_cosine_half_period_amplitude_error real,
    geom_model_cosine_half_period_phase real,
    geom_model_cosine_half_period_phase_error real,
    model_type text,
    num_model_parameters smallint,
    reduced_chi2 real,
    derived_primary_ecl_phase real,
    derived_primary_ecl_phase_error real,
    derived_primary_ecl_duration real,
    derived_primary_ecl_duration_error real,
    derived_primary_ecl_depth real,
    derived_primary_ecl_depth_error real,
    derived_secondary_ecl_phase real,
    derived_secondary_ecl_phase_error real,
    derived_secondary_ecl_duration real,
    derived_secondary_ecl_duration_error real,
    derived_secondary_ecl_depth real,
    derived_secondary_ecl_depth_error real
);
COMMENT ON TABLE gaiadr3.vari_eclipsing_binary IS 'This table describes the properties of the eclipsing binaries resulting from the variability analysis.';
COMMENT ON COLUMN gaiadr3.vari_eclipsing_binary.solution_id IS 'Solution Identifier';
COMMENT ON COLUMN gaiadr3.vari_eclipsing_binary.source_id IS 'Unique source identifier';
COMMENT ON COLUMN gaiadr3.vari_eclipsing_binary.global_ranking IS 'Number between 0 (worst) and 1 (best)';
COMMENT ON COLUMN gaiadr3.vari_eclipsing_binary.reference_time IS 'Reference time used for the geometric model fit [d]';
COMMENT ON COLUMN gaiadr3.vari_eclipsing_binary.frequency IS 'Frequency of geometric model of the eclipsing binary light curve [d**-1]';
COMMENT ON COLUMN gaiadr3.vari_eclipsing_binary.frequency_error IS 'Uncertainty of \texttt{frequency} [d**-1]';
COMMENT ON COLUMN gaiadr3.vari_eclipsing_binary.geom_model_reference_level IS 'Magnitude reference level of geometric model [mag]';
COMMENT ON COLUMN gaiadr3.vari_eclipsing_binary.geom_model_reference_level_error IS 'Uncertainty of \texttt{geomModelReferenceLevel} [mag]';
COMMENT ON COLUMN gaiadr3.vari_eclipsing_binary.geom_model_gaussian1_phase IS 'Phase of the Gaussian 1 component';
COMMENT ON COLUMN gaiadr3.vari_eclipsing_binary.geom_model_gaussian1_phase_error IS 'Uncertainty of \texttt{geomModelGaussian1Phase}';
COMMENT ON COLUMN gaiadr3.vari_eclipsing_binary.geom_model_gaussian1_sigma IS 'Standard deviation [phase] of Gaussian 1 component';
COMMENT ON COLUMN gaiadr3.vari_eclipsing_binary.geom_model_gaussian1_sigma_error IS 'Uncertainty of \texttt{geomModelGaussian1Sigma}';
COMMENT ON COLUMN gaiadr3.vari_eclipsing_binary.geom_model_gaussian1_depth IS 'Magnitude depth of Gaussian 1 component [mag]';
COMMENT ON COLUMN gaiadr3.vari_eclipsing_binary.geom_model_gaussian1_depth_error IS 'Uncertainty of \texttt{geomModelGaussian1Depth} [mag]';
COMMENT ON COLUMN gaiadr3.vari_eclipsing_binary.geom_model_gaussian2_phase IS 'Phase of Gaussian 2 component';
COMMENT ON COLUMN gaiadr3.vari_eclipsing_binary.geom_model_gaussian2_phase_error IS 'Uncertainty of \texttt{geomModelGaussian2Phase}';
COMMENT ON COLUMN gaiadr3.vari_eclipsing_binary.geom_model_gaussian2_sigma IS 'Standard deviation [phase] of Gaussian 2 component';
COMMENT ON COLUMN gaiadr3.vari_eclipsing_binary.geom_model_gaussian2_sigma_error IS 'Uncertainty of \texttt{geomModelGaussian2Sigma}';
COMMENT ON COLUMN gaiadr3.vari_eclipsing_binary.geom_model_gaussian2_depth IS 'Magnitude depth of Gaussian2 component [mag]';
COMMENT ON COLUMN gaiadr3.vari_eclipsing_binary.geom_model_gaussian2_depth_error IS 'Uncertainty of \texttt{geomModelGaussian2Depth} [mag]';
COMMENT ON COLUMN gaiadr3.vari_eclipsing_binary.geom_model_cosine_half_period_amplitude IS 'Amplitude of the cosine component with half the period of the geometric model [mag]';
COMMENT ON COLUMN gaiadr3.vari_eclipsing_binary.geom_model_cosine_half_period_amplitude_error IS 'Uncertainty of \texttt{geomModelCosineHalfPeriodAmplitude} [mag]';
COMMENT ON COLUMN gaiadr3.vari_eclipsing_binary.geom_model_cosine_half_period_phase IS 'Reference phase of the cosine component with half the period of the geometric model';
COMMENT ON COLUMN gaiadr3.vari_eclipsing_binary.geom_model_cosine_half_period_phase_error IS 'Uncertainty of \texttt{geomModelCosineHalfPeriodPhase}';
COMMENT ON COLUMN gaiadr3.vari_eclipsing_binary.model_type IS 'Type of geometrical model of the light curve';
COMMENT ON COLUMN gaiadr3.vari_eclipsing_binary.num_model_parameters IS 'Number of free parameters of the geometric model';
COMMENT ON COLUMN gaiadr3.vari_eclipsing_binary.reduced_chi2 IS 'Reduced Chi2 of the geometrical model fit';
COMMENT ON COLUMN gaiadr3.vari_eclipsing_binary.derived_primary_ecl_phase IS 'Primary eclipse: phase at geometrically deepest point';
COMMENT ON COLUMN gaiadr3.vari_eclipsing_binary.derived_primary_ecl_phase_error IS 'Primary eclipse: uncertainty of \texttt{derivedPrimaryEclPhase}';
COMMENT ON COLUMN gaiadr3.vari_eclipsing_binary.derived_primary_ecl_duration IS 'Primary eclipse: duration [phase fraction]';
COMMENT ON COLUMN gaiadr3.vari_eclipsing_binary.derived_primary_ecl_duration_error IS 'Primary eclipse: uncertainty of \texttt{derivedPrimaryEclDuration}';
COMMENT ON COLUMN gaiadr3.vari_eclipsing_binary.derived_primary_ecl_depth IS 'Primary eclipse: depth [mag]';
COMMENT ON COLUMN gaiadr3.vari_eclipsing_binary.derived_primary_ecl_depth_error IS 'Primary eclipse: uncertainty of \texttt{derivedPrimaryEclDepth} [mag]';
COMMENT ON COLUMN gaiadr3.vari_eclipsing_binary.derived_secondary_ecl_phase IS 'Secondary eclipse: phase at geometrically second deepest point';
COMMENT ON COLUMN gaiadr3.vari_eclipsing_binary.derived_secondary_ecl_phase_error IS 'Secondary eclipse: uncertainty of \texttt{derivedSecondaryEclPhase}';
COMMENT ON COLUMN gaiadr3.vari_eclipsing_binary.derived_secondary_ecl_duration IS 'Secondary eclipse: duration [phase fraction]';
COMMENT ON COLUMN gaiadr3.vari_eclipsing_binary.derived_secondary_ecl_duration_error IS 'Secondary eclipse: uncertainty of \texttt{derivedSecondaryEclDuration}';
COMMENT ON COLUMN gaiadr3.vari_eclipsing_binary.derived_secondary_ecl_depth IS 'Secondary eclipse: depth [mag]';
COMMENT ON COLUMN gaiadr3.vari_eclipsing_binary.derived_secondary_ecl_depth_error IS 'Secondary eclipse: uncertainty of \texttt{derivedSecondaryEclDepth} [mag]';
CREATE INDEX IF NOT EXISTS gaiadr3_vari_eclipsing_binary_source_id_idx ON gaiadr3.vari_eclipsing_binary (source_id);

-- [Variabilidad] gaiadr3.vari_epoch_radial_velocity — acceso: TAP Gaia (ADQL)
CREATE TABLE IF NOT EXISTS gaiadr3.vari_epoch_radial_velocity (
    source_id bigint,
    transit_id bigint,
    rv_obs_time double precision,
    radial_velocity double precision,
    radial_velocity_error double precision,
    rejected_by_variability boolean,
    solution_id bigint
);
COMMENT ON TABLE gaiadr3.vari_epoch_radial_velocity IS 'This table contains the epoch radial velocity data points for a sub-set of variable stars. Each entry is a radial velocity in the solar barycentric reference frame for a given object and observation time.';
COMMENT ON COLUMN gaiadr3.vari_epoch_radial_velocity.source_id IS 'Unique source identifier (unique within a particular Data Release)';
COMMENT ON COLUMN gaiadr3.vari_epoch_radial_velocity.transit_id IS 'Transit unique identifier';
COMMENT ON COLUMN gaiadr3.vari_epoch_radial_velocity.rv_obs_time IS 'Observing time of the transit [d]';
COMMENT ON COLUMN gaiadr3.vari_epoch_radial_velocity.radial_velocity IS 'Barycentric radial velocity [km.s**-1]';
COMMENT ON COLUMN gaiadr3.vari_epoch_radial_velocity.radial_velocity_error IS 'Barycentric radial velocity error [km.s**-1]';
COMMENT ON COLUMN gaiadr3.vari_epoch_radial_velocity.rejected_by_variability IS 'Rejected by DPAC variability processing (or variability analysis)';
COMMENT ON COLUMN gaiadr3.vari_epoch_radial_velocity.solution_id IS 'Solution Identifier';
CREATE INDEX IF NOT EXISTS gaiadr3_vari_epoch_radial_velocity_source_id_idx ON gaiadr3.vari_epoch_radial_velocity (source_id);

-- [Variabilidad] gaiadr3.vari_long_period_variable — acceso: TAP Gaia (ADQL)
CREATE TABLE IF NOT EXISTS gaiadr3.vari_long_period_variable (
    solution_id bigint,
    source_id bigint,
    frequency double precision,
    frequency_error real,
    amplitude real,
    median_delta_wl_rp real,
    is_cstar boolean
);
COMMENT ON TABLE gaiadr3.vari_long_period_variable IS 'This table describes the Long Period Variable stars. Some entries can be NaN when absent.';
COMMENT ON COLUMN gaiadr3.vari_long_period_variable.solution_id IS 'Solution Identifier';
COMMENT ON COLUMN gaiadr3.vari_long_period_variable.source_id IS 'Unique source identifier';
COMMENT ON COLUMN gaiadr3.vari_long_period_variable.frequency IS 'Frequency of the LPV [d**-1]';
COMMENT ON COLUMN gaiadr3.vari_long_period_variable.frequency_error IS 'Error on the frequency [d**-1]';
COMMENT ON COLUMN gaiadr3.vari_long_period_variable.amplitude IS 'Amplitude of the LPV variability [mag]';
COMMENT ON COLUMN gaiadr3.vari_long_period_variable.median_delta_wl_rp IS 'Median of the pseudo-wavelength separations between the two highest peaks in RP spectra';
COMMENT ON COLUMN gaiadr3.vari_long_period_variable.is_cstar IS 'Flag to mark C-stars';
CREATE INDEX IF NOT EXISTS gaiadr3_vari_long_period_variable_source_id_idx ON gaiadr3.vari_long_period_variable (source_id);

-- [Variabilidad] gaiadr3.vari_microlensing — acceso: TAP Gaia (ADQL)
CREATE TABLE IF NOT EXISTS gaiadr3.vari_microlensing (
    solution_id bigint,
    source_id bigint,
    paczynski0_g0 real,
    paczynski0_g0_error real,
    paczynski0_bp0 real,
    paczynski0_bp0_error real,
    paczynski0_rp0 real,
    paczynski0_rp0_error real,
    paczynski0_u0 double precision,
    paczynski0_u0_error double precision,
    paczynski0_te real,
    paczynski0_te_error real,
    paczynski0_tmax double precision,
    paczynski0_tmax_error double precision,
    paczynski0_chi2 real,
    paczynski0_chi2_dof real,
    paczynski1_g0 real,
    paczynski1_g0_error real,
    paczynski1_bp0 real,
    paczynski1_bp0_error real,
    paczynski1_rp0 real,
    paczynski1_rp0_error real,
    paczynski1_u0 double precision,
    paczynski1_u0_error double precision,
    paczynski1_te real,
    paczynski1_te_error real,
    paczynski1_tmax double precision,
    paczynski1_tmax_error double precision,
    paczynski1_fs_g real,
    paczynski1_fs_g_error real,
    paczynski1_fs_bp real,
    paczynski1_fs_bp_error real,
    paczynski1_fs_rp real,
    paczynski1_fs_rp_error real,
    paczynski1_chi2 real,
    paczynski1_chi2_dof real
);
COMMENT ON TABLE gaiadr3.vari_microlensing IS 'This table describes the microlensing events.';
COMMENT ON COLUMN gaiadr3.vari_microlensing.solution_id IS 'Solution Identifier';
COMMENT ON COLUMN gaiadr3.vari_microlensing.source_id IS 'Unique source identifier';
COMMENT ON COLUMN gaiadr3.vari_microlensing.paczynski0_g0 IS 'G-band magnitude baseline (level 0) [mag]';
COMMENT ON COLUMN gaiadr3.vari_microlensing.paczynski0_g0_error IS 'Error of G-band magnitude baseline (level 0) [mag]';
COMMENT ON COLUMN gaiadr3.vari_microlensing.paczynski0_bp0 IS 'BP-band magnitude baseline (level 0) [mag]';
COMMENT ON COLUMN gaiadr3.vari_microlensing.paczynski0_bp0_error IS 'Error of BP-band magnitude baseline (level 0) [mag]';
COMMENT ON COLUMN gaiadr3.vari_microlensing.paczynski0_rp0 IS 'RP-band magnitude baseline (level 0) [mag]';
COMMENT ON COLUMN gaiadr3.vari_microlensing.paczynski0_rp0_error IS 'Error of RP-band magnitude baseline (level 0) [mag]';
COMMENT ON COLUMN gaiadr3.vari_microlensing.paczynski0_u0 IS 'Impact parameter (level 0)';
COMMENT ON COLUMN gaiadr3.vari_microlensing.paczynski0_u0_error IS 'Error of the impact parameter (level 0)';
COMMENT ON COLUMN gaiadr3.vari_microlensing.paczynski0_te IS 'Event timescale (level 0) [d]';
COMMENT ON COLUMN gaiadr3.vari_microlensing.paczynski0_te_error IS 'Error of event timescale (level 0) [d]';
COMMENT ON COLUMN gaiadr3.vari_microlensing.paczynski0_tmax IS 'Time of maximum amplification (level 0) [d]';
COMMENT ON COLUMN gaiadr3.vari_microlensing.paczynski0_tmax_error IS 'Error of time of maximum amplification (level 0) [d]';
COMMENT ON COLUMN gaiadr3.vari_microlensing.paczynski0_chi2 IS 'Chi square of level 0 Paczynski fit';
COMMENT ON COLUMN gaiadr3.vari_microlensing.paczynski0_chi2_dof IS 'Reduced chi square of level 0 Paczynski fit';
COMMENT ON COLUMN gaiadr3.vari_microlensing.paczynski1_g0 IS 'G-band magnitude baseline (level 1) [mag]';
COMMENT ON COLUMN gaiadr3.vari_microlensing.paczynski1_g0_error IS 'Error of G-band magnitude baseline (level 1) [mag]';
COMMENT ON COLUMN gaiadr3.vari_microlensing.paczynski1_bp0 IS 'BP-band magnitude baseline (level 1) [mag]';
COMMENT ON COLUMN gaiadr3.vari_microlensing.paczynski1_bp0_error IS 'Error of BP-band magnitude baseline (level 1) [mag]';
COMMENT ON COLUMN gaiadr3.vari_microlensing.paczynski1_rp0 IS 'RP-band magnitude baseline (level 1) [mag]';
COMMENT ON COLUMN gaiadr3.vari_microlensing.paczynski1_rp0_error IS 'Error of RP-band magnitude baseline (level 1) [mag]';
COMMENT ON COLUMN gaiadr3.vari_microlensing.paczynski1_u0 IS 'Impact parameter (level 1)';
COMMENT ON COLUMN gaiadr3.vari_microlensing.paczynski1_u0_error IS 'Error of the impact parameter (level 1)';
COMMENT ON COLUMN gaiadr3.vari_microlensing.paczynski1_te IS 'Event timescale (level 1) [d]';
COMMENT ON COLUMN gaiadr3.vari_microlensing.paczynski1_te_error IS 'Error of event timescale (level 1) [d]';
COMMENT ON COLUMN gaiadr3.vari_microlensing.paczynski1_tmax IS 'Time of maximum amplification (level 1) [d]';
COMMENT ON COLUMN gaiadr3.vari_microlensing.paczynski1_tmax_error IS 'Error of time of maximum amplification (level 1) [d]';
COMMENT ON COLUMN gaiadr3.vari_microlensing.paczynski1_fs_g IS 'Blending factor in G-band (level 1)';
COMMENT ON COLUMN gaiadr3.vari_microlensing.paczynski1_fs_g_error IS 'Error of blending factor in G-band (level 1)';
COMMENT ON COLUMN gaiadr3.vari_microlensing.paczynski1_fs_bp IS 'Blending factor in BP-band (level 1)';
COMMENT ON COLUMN gaiadr3.vari_microlensing.paczynski1_fs_bp_error IS 'Error of blending factor in BP-band (level 1)';
COMMENT ON COLUMN gaiadr3.vari_microlensing.paczynski1_fs_rp IS 'Blending factor in RP-band (level 1)';
COMMENT ON COLUMN gaiadr3.vari_microlensing.paczynski1_fs_rp_error IS 'Error of blending factor in RP-band (level 1)';
COMMENT ON COLUMN gaiadr3.vari_microlensing.paczynski1_chi2 IS 'Chi square of level 1 Paczynski fit';
COMMENT ON COLUMN gaiadr3.vari_microlensing.paczynski1_chi2_dof IS 'Reduced chi square of level 1 Paczynski fit';
CREATE INDEX IF NOT EXISTS gaiadr3_vari_microlensing_source_id_idx ON gaiadr3.vari_microlensing (source_id);

-- [Variabilidad] gaiadr3.vari_ms_oscillator — acceso: TAP Gaia (ADQL)
CREATE TABLE IF NOT EXISTS gaiadr3.vari_ms_oscillator (
    solution_id bigint,
    source_id bigint,
    frequency1 double precision,
    fap_g_freq1 real,
    amplitude_g_freq1 real,
    phase_g_freq1 real,
    num_harmonics smallint,
    amplitude_g_freq1_harm2 real,
    phase_g_freq1_harm2 real,
    amplitude_g_freq1_harm3 real,
    phase_g_freq1_harm3 real
);
COMMENT ON TABLE gaiadr3.vari_ms_oscillator IS 'This table describes the main-sequence oscillators.';
COMMENT ON COLUMN gaiadr3.vari_ms_oscillator.solution_id IS 'Solution Identifier';
COMMENT ON COLUMN gaiadr3.vari_ms_oscillator.source_id IS 'Unique source identifier';
COMMENT ON COLUMN gaiadr3.vari_ms_oscillator.frequency1 IS 'Best frequency [d**-1]';
COMMENT ON COLUMN gaiadr3.vari_ms_oscillator.fap_g_freq1 IS 'False alarm probability corresponding to the best frequency';
COMMENT ON COLUMN gaiadr3.vari_ms_oscillator.amplitude_g_freq1 IS 'Half peak-to-peak amplitude in the G band of the best frequency [mag]';
COMMENT ON COLUMN gaiadr3.vari_ms_oscillator.phase_g_freq1 IS 'Phase of the oscillation in the G band corresponding to best frequency [rad]';
COMMENT ON COLUMN gaiadr3.vari_ms_oscillator.num_harmonics IS 'Number of significant harmonics of the best frequency';
COMMENT ON COLUMN gaiadr3.vari_ms_oscillator.amplitude_g_freq1_harm2 IS 'Half peak-to-peak amplitude in the G band of the second harmonic of the best frequency [mag]';
COMMENT ON COLUMN gaiadr3.vari_ms_oscillator.phase_g_freq1_harm2 IS 'Phase of the oscillation in the G band corresponding to the second harmonic of the best frequency [rad]';
COMMENT ON COLUMN gaiadr3.vari_ms_oscillator.amplitude_g_freq1_harm3 IS 'Half peak-to-peak amplitude in the G band of the third harmonic of the best frequency [mag]';
COMMENT ON COLUMN gaiadr3.vari_ms_oscillator.phase_g_freq1_harm3 IS 'Phase of the oscillation in the G band corresponding to the third harmonic of the best frequency [rad]';
CREATE INDEX IF NOT EXISTS gaiadr3_vari_ms_oscillator_source_id_idx ON gaiadr3.vari_ms_oscillator (source_id);

-- [Variabilidad] gaiadr3.vari_planetary_transit — acceso: TAP Gaia (ADQL)
CREATE TABLE IF NOT EXISTS gaiadr3.vari_planetary_transit (
    solution_id bigint,
    source_id bigint,
    transit_reference_time double precision,
    transit_period double precision,
    transit_depth real,
    transit_duration real,
    num_in_transit smallint
);
COMMENT ON TABLE gaiadr3.vari_planetary_transit IS 'This table describes the Planetary Transit candidate events.';
COMMENT ON COLUMN gaiadr3.vari_planetary_transit.solution_id IS 'Solution Identifier';
COMMENT ON COLUMN gaiadr3.vari_planetary_transit.source_id IS 'Unique source identifier';
COMMENT ON COLUMN gaiadr3.vari_planetary_transit.transit_reference_time IS 'Mid-transit reference time [d]';
COMMENT ON COLUMN gaiadr3.vari_planetary_transit.transit_period IS 'Most probable transit period [d]';
COMMENT ON COLUMN gaiadr3.vari_planetary_transit.transit_depth IS 'Transit depth [mmag]';
COMMENT ON COLUMN gaiadr3.vari_planetary_transit.transit_duration IS 'Transit duration [d]';
COMMENT ON COLUMN gaiadr3.vari_planetary_transit.num_in_transit IS 'Number of in-transit observations';
CREATE INDEX IF NOT EXISTS gaiadr3_vari_planetary_transit_source_id_idx ON gaiadr3.vari_planetary_transit (source_id);

-- [Variabilidad] gaiadr3.vari_planetary_transit_13june2022 — acceso: TAP Gaia (ADQL)
CREATE TABLE IF NOT EXISTS gaiadr3.vari_planetary_transit_13june2022 (
    solution_id bigint,
    source_id bigint,
    transit_reference_time double precision,
    transit_period double precision,
    transit_depth real,
    transit_duration real,
    num_in_transit smallint
);
COMMENT ON TABLE gaiadr3.vari_planetary_transit_13june2022 IS 'This table describes the Planetary Transit candidate events.';
COMMENT ON COLUMN gaiadr3.vari_planetary_transit_13june2022.solution_id IS 'Solution Identifier';
COMMENT ON COLUMN gaiadr3.vari_planetary_transit_13june2022.source_id IS 'Unique source identifier';
COMMENT ON COLUMN gaiadr3.vari_planetary_transit_13june2022.transit_reference_time IS 'Mid-transit reference time [d]';
COMMENT ON COLUMN gaiadr3.vari_planetary_transit_13june2022.transit_period IS 'Most probable transit period [d]';
COMMENT ON COLUMN gaiadr3.vari_planetary_transit_13june2022.transit_depth IS 'Transit depth [mmag]';
COMMENT ON COLUMN gaiadr3.vari_planetary_transit_13june2022.transit_duration IS 'Transit duration [d]';
COMMENT ON COLUMN gaiadr3.vari_planetary_transit_13june2022.num_in_transit IS 'Number of in-transit observations';
CREATE INDEX IF NOT EXISTS gaiadr3_vari_planetary_transit_13june2022_source_id_idx ON gaiadr3.vari_planetary_transit_13june2022 (source_id);

-- [Variabilidad] gaiadr3.vari_rad_vel_statistics — acceso: TAP Gaia (ADQL)
CREATE TABLE IF NOT EXISTS gaiadr3.vari_rad_vel_statistics (
    solution_id bigint,
    source_id bigint,
    num_selected_rv smallint,
    mean_obs_time_rv double precision,
    time_duration_rv real,
    min_rv real,
    max_rv real,
    mean_rv real,
    median_rv real,
    range_rv real,
    std_dev_rv real,
    skewness_rv real,
    kurtosis_rv real,
    mad_rv real,
    abbe_rv real,
    iqr_rv real
);
COMMENT ON TABLE gaiadr3.vari_rad_vel_statistics IS 'Statistical parameters of radial velocity time series, using only transits not rejected, see {\tt rejectedByVariability} column in {\tt VariEpochRadialVelocity}. Note that NaN will be reported when the parameter value is missing or cannot be calculated.';
COMMENT ON COLUMN gaiadr3.vari_rad_vel_statistics.solution_id IS 'Solution Identifier';
COMMENT ON COLUMN gaiadr3.vari_rad_vel_statistics.source_id IS 'Unique source identifier';
COMMENT ON COLUMN gaiadr3.vari_rad_vel_statistics.num_selected_rv IS 'Total number of radial velocity transits selected for variability analysis';
COMMENT ON COLUMN gaiadr3.vari_rad_vel_statistics.mean_obs_time_rv IS 'Mean observation time for radial velocity transits [d]';
COMMENT ON COLUMN gaiadr3.vari_rad_vel_statistics.time_duration_rv IS 'Time duration of the time series for radial velocity transits [d]';
COMMENT ON COLUMN gaiadr3.vari_rad_vel_statistics.min_rv IS 'Minimum radial velocity [km.s**-1]';
COMMENT ON COLUMN gaiadr3.vari_rad_vel_statistics.max_rv IS 'Maximum radial velocity [km.s**-1]';
COMMENT ON COLUMN gaiadr3.vari_rad_vel_statistics.mean_rv IS 'Mean radial velocity [km.s**-1]';
COMMENT ON COLUMN gaiadr3.vari_rad_vel_statistics.median_rv IS 'Median radial velocity [km.s**-1]';
COMMENT ON COLUMN gaiadr3.vari_rad_vel_statistics.range_rv IS 'Difference between the highest and lowest radial velocity transits [km.s**-1]';
COMMENT ON COLUMN gaiadr3.vari_rad_vel_statistics.std_dev_rv IS 'Square root of the unweighted radial velocity variance [km.s**-1]';
COMMENT ON COLUMN gaiadr3.vari_rad_vel_statistics.skewness_rv IS 'Standardized unweighted radial velocity skewness';
COMMENT ON COLUMN gaiadr3.vari_rad_vel_statistics.kurtosis_rv IS 'Standardized unweighted radial velocity kurtosis';
COMMENT ON COLUMN gaiadr3.vari_rad_vel_statistics.mad_rv IS 'Median Absolute Deviation (MAD) for radial velocity transits [km.s**-1]';
COMMENT ON COLUMN gaiadr3.vari_rad_vel_statistics.abbe_rv IS 'Abbe value for radial velocity transits';
COMMENT ON COLUMN gaiadr3.vari_rad_vel_statistics.iqr_rv IS 'Interquartile range for radial velocity transits [km.s**-1]';
CREATE INDEX IF NOT EXISTS gaiadr3_vari_rad_vel_statistics_source_id_idx ON gaiadr3.vari_rad_vel_statistics (source_id);

-- [Variabilidad] gaiadr3.vari_rotation_modulation — acceso: TAP Gaia (ADQL)
CREATE TABLE IF NOT EXISTS gaiadr3.vari_rotation_modulation (
    solution_id bigint,
    source_id bigint,
    num_segments smallint,
    segments_start_time double precision[],
    segments_end_time double precision[],
    segments_colour_mag_intercept real[],
    segments_colour_mag_intercept_error real[],
    segments_colour_mag_slope real[],
    segments_colour_mag_slope_error real[],
    segments_correlation_coefficient real[],
    segments_correlation_significance real[],
    num_outliers smallint,
    outliers_time double precision[],
    segments_rotation_period double precision[],
    segments_rotation_period_error real[],
    segments_rotation_period_fap real[],
    best_rotation_period double precision,
    best_rotation_period_error real,
    segments_g_unspotted real[],
    segments_g_unspotted_error real[],
    segments_bp_unspotted real[],
    segments_bp_unspotted_error real[],
    segments_rp_unspotted real[],
    segments_rp_unspotted_error real[],
    g_unspotted real,
    g_unspotted_error real,
    bp_unspotted real,
    bp_unspotted_error real,
    rp_unspotted real,
    rp_unspotted_error real,
    segments_g_cos_term real[],
    segments_g_cos_term_error real[],
    segments_g_sin_term real[],
    segments_g_sin_term_error real[],
    segments_g_a0_term real[],
    segments_g_a0_term_error real[],
    segments_bp_cos_term real[],
    segments_bp_cos_term_error real[],
    segments_bp_sin_term real[],
    segments_bp_sin_term_error real[],
    segments_bp_a0_term real[],
    segments_bp_a0_term_error real[],
    segments_rp_cos_term real[],
    segments_rp_cos_term_error real[],
    segments_rp_sin_term real[],
    segments_rp_sin_term_error real[],
    segments_rp_a0_term real[],
    segments_rp_a0_term_error real[],
    segments_g_activity_index real[],
    segments_g_activity_index_error real[],
    segments_bp_activity_index real[],
    segments_bp_activity_index_error real[],
    segments_rp_activity_index real[],
    segments_rp_activity_index_error real[],
    max_activity_index_g real,
    max_activity_index_g_error real,
    segments_bp_rp_corr_coeff real[],
    segments_bp_rp_corr_signif real[],
    segments_bp_rp_intercept real[],
    segments_bp_rp_intercept_error real[],
    segments_bp_rp_slope real[],
    segments_bp_rp_slope_error real[],
    segments_model_reference_time double precision[],
    segments_g_chi_square real[],
    segments_bp_chi_square real[],
    segments_rp_chi_square real[]
);
COMMENT ON TABLE gaiadr3.vari_rotation_modulation IS 'This table describes the solar-like stars with rotational modulation.';
COMMENT ON COLUMN gaiadr3.vari_rotation_modulation.solution_id IS 'Solution Identifier';
COMMENT ON COLUMN gaiadr3.vari_rotation_modulation.source_id IS 'Unique source identifier';
COMMENT ON COLUMN gaiadr3.vari_rotation_modulation.num_segments IS 'Number of segments';
COMMENT ON COLUMN gaiadr3.vari_rotation_modulation.segments_start_time IS 'Times at which segments start [d]';
COMMENT ON COLUMN gaiadr3.vari_rotation_modulation.segments_end_time IS 'Times at which segments end [d]';
COMMENT ON COLUMN gaiadr3.vari_rotation_modulation.segments_colour_mag_intercept IS 'Colour-Magnitude Intercept in segments';
COMMENT ON COLUMN gaiadr3.vari_rotation_modulation.segments_colour_mag_intercept_error IS 'Colour-Magnitude Intercept uncertainty in segments';
COMMENT ON COLUMN gaiadr3.vari_rotation_modulation.segments_colour_mag_slope IS 'Colour-Magnitude Slope in segments';
COMMENT ON COLUMN gaiadr3.vari_rotation_modulation.segments_colour_mag_slope_error IS 'Colour-Magnitude Slope uncertainty in segments';
COMMENT ON COLUMN gaiadr3.vari_rotation_modulation.segments_correlation_coefficient IS 'Correlation coefficient in segments';
COMMENT ON COLUMN gaiadr3.vari_rotation_modulation.segments_correlation_significance IS 'Correlation coefficient significance in segments';
COMMENT ON COLUMN gaiadr3.vari_rotation_modulation.num_outliers IS 'Number of outliers';
COMMENT ON COLUMN gaiadr3.vari_rotation_modulation.outliers_time IS 'Times at which outliers occurs [d]';
COMMENT ON COLUMN gaiadr3.vari_rotation_modulation.segments_rotation_period IS 'Rotation period in segment [d]';
COMMENT ON COLUMN gaiadr3.vari_rotation_modulation.segments_rotation_period_error IS 'Rotation period uncertainty in segment [d]';
COMMENT ON COLUMN gaiadr3.vari_rotation_modulation.segments_rotation_period_fap IS 'FAP on rotation period in segment';
COMMENT ON COLUMN gaiadr3.vari_rotation_modulation.best_rotation_period IS 'Best rotation period [d]';
COMMENT ON COLUMN gaiadr3.vari_rotation_modulation.best_rotation_period_error IS 'Error on best rotation period [d]';
COMMENT ON COLUMN gaiadr3.vari_rotation_modulation.segments_g_unspotted IS 'The unspotted G mags in segment [mag]';
COMMENT ON COLUMN gaiadr3.vari_rotation_modulation.segments_g_unspotted_error IS 'The unspotted G mag uncertainties in segment [mag]';
COMMENT ON COLUMN gaiadr3.vari_rotation_modulation.segments_bp_unspotted IS 'The unspotted BP mag in segment [mag]';
COMMENT ON COLUMN gaiadr3.vari_rotation_modulation.segments_bp_unspotted_error IS 'The unspotted BP mag uncertainties in segment [mag]';
COMMENT ON COLUMN gaiadr3.vari_rotation_modulation.segments_rp_unspotted IS 'The unspotted RP mag in segment [mag]';
COMMENT ON COLUMN gaiadr3.vari_rotation_modulation.segments_rp_unspotted_error IS 'The unspotted RP mag uncertainties in segment [mag]';
COMMENT ON COLUMN gaiadr3.vari_rotation_modulation.g_unspotted IS 'Unspotted G mag [mag]';
COMMENT ON COLUMN gaiadr3.vari_rotation_modulation.g_unspotted_error IS 'Unspotted G mag uncertainty [mag]';
COMMENT ON COLUMN gaiadr3.vari_rotation_modulation.bp_unspotted IS 'Unspotted BP mag [mag]';
COMMENT ON COLUMN gaiadr3.vari_rotation_modulation.bp_unspotted_error IS 'Unspotted BP mag uncertainty [mag]';
COMMENT ON COLUMN gaiadr3.vari_rotation_modulation.rp_unspotted IS 'Unspotted RP mag [mag]';
COMMENT ON COLUMN gaiadr3.vari_rotation_modulation.rp_unspotted_error IS 'Unspotted RP mag uncertainty [mag]';
COMMENT ON COLUMN gaiadr3.vari_rotation_modulation.segments_g_cos_term IS 'Coefficient of cosine term of linear fit in segment in the G band [mag]';
COMMENT ON COLUMN gaiadr3.vari_rotation_modulation.segments_g_cos_term_error IS 'Errors on cosine terms in the G band [mag]';
COMMENT ON COLUMN gaiadr3.vari_rotation_modulation.segments_g_sin_term IS 'Coefficient of sine term of linear fit in segment in the G band [mag]';
COMMENT ON COLUMN gaiadr3.vari_rotation_modulation.segments_g_sin_term_error IS 'Errors on sine terms in the G band [mag]';
COMMENT ON COLUMN gaiadr3.vari_rotation_modulation.segments_g_a0_term IS 'Constant term (A0) of linear fit in segment in the G band [mag]';
COMMENT ON COLUMN gaiadr3.vari_rotation_modulation.segments_g_a0_term_error IS 'Errors on constant terms in the G band [mag]';
COMMENT ON COLUMN gaiadr3.vari_rotation_modulation.segments_bp_cos_term IS 'Coefficient of cosine term of linear fit in segment in the BP band [mag]';
COMMENT ON COLUMN gaiadr3.vari_rotation_modulation.segments_bp_cos_term_error IS 'Errors on cosine terms in the BP band [mag]';
COMMENT ON COLUMN gaiadr3.vari_rotation_modulation.segments_bp_sin_term IS 'Coefficient of sine term of linear fit in segment in the BP band [mag]';
COMMENT ON COLUMN gaiadr3.vari_rotation_modulation.segments_bp_sin_term_error IS 'Errors on sine terms in the BP band [mag]';
COMMENT ON COLUMN gaiadr3.vari_rotation_modulation.segments_bp_a0_term IS 'Constant term (A0) of linear fit in segment in the BP band [mag]';
COMMENT ON COLUMN gaiadr3.vari_rotation_modulation.segments_bp_a0_term_error IS 'Errors on constant terms in the BP band [mag]';
COMMENT ON COLUMN gaiadr3.vari_rotation_modulation.segments_rp_cos_term IS 'Coefficient of cosine term of linear fit in segment in the RP band [mag]';
COMMENT ON COLUMN gaiadr3.vari_rotation_modulation.segments_rp_cos_term_error IS 'Errors on cosine terms in the RP band [mag]';
COMMENT ON COLUMN gaiadr3.vari_rotation_modulation.segments_rp_sin_term IS 'Coefficient of sine term of linear fit in segment in the RP band [mag]';
COMMENT ON COLUMN gaiadr3.vari_rotation_modulation.segments_rp_sin_term_error IS 'Errors on sine terms in the RP band [mag]';
COMMENT ON COLUMN gaiadr3.vari_rotation_modulation.segments_rp_a0_term IS 'Constant term (A0) of linear fit in segment in the RP band [mag]';
COMMENT ON COLUMN gaiadr3.vari_rotation_modulation.segments_rp_a0_term_error IS 'Errors on constant terms in the RP band [mag]';
COMMENT ON COLUMN gaiadr3.vari_rotation_modulation.segments_g_activity_index IS 'Activity Index in segment (computed in G band) [mag]';
COMMENT ON COLUMN gaiadr3.vari_rotation_modulation.segments_g_activity_index_error IS 'error on Activity index in segment (computed in G band) [mag]';
COMMENT ON COLUMN gaiadr3.vari_rotation_modulation.segments_bp_activity_index IS 'Activity Index in segment (computed in BP band) [mag]';
COMMENT ON COLUMN gaiadr3.vari_rotation_modulation.segments_bp_activity_index_error IS 'error on Activity index in segment (computed in BP band) [mag]';
COMMENT ON COLUMN gaiadr3.vari_rotation_modulation.segments_rp_activity_index IS 'Activity Index in segment (computed in RP band) [mag]';
COMMENT ON COLUMN gaiadr3.vari_rotation_modulation.segments_rp_activity_index_error IS 'error on Activity index in segment (computed in RP band) [mag]';
COMMENT ON COLUMN gaiadr3.vari_rotation_modulation.max_activity_index_g IS 'The maximum Activity Index in the G band [mag]';
COMMENT ON COLUMN gaiadr3.vari_rotation_modulation.max_activity_index_g_error IS 'Error on maximum activity index in the G band [mag]';
COMMENT ON COLUMN gaiadr3.vari_rotation_modulation.segments_bp_rp_corr_coeff IS 'Pearson coefficient between BP and RP in segment';
COMMENT ON COLUMN gaiadr3.vari_rotation_modulation.segments_bp_rp_corr_signif IS 'Significance associated with Pearson coefficient';
COMMENT ON COLUMN gaiadr3.vari_rotation_modulation.segments_bp_rp_intercept IS 'Intercept of regression fit of RP vs BP magnitudes in the segment [mag]';
COMMENT ON COLUMN gaiadr3.vari_rotation_modulation.segments_bp_rp_intercept_error IS 'Error on intercept of regression fit of RP vs BP magnitudes in the segment [mag]';
COMMENT ON COLUMN gaiadr3.vari_rotation_modulation.segments_bp_rp_slope IS 'Slope of regression fit of RP vs BP magnitudes in the segment';
COMMENT ON COLUMN gaiadr3.vari_rotation_modulation.segments_bp_rp_slope_error IS 'Error on slope of regression fit of RP vs BP magnitudes in the segment';
COMMENT ON COLUMN gaiadr3.vari_rotation_modulation.segments_model_reference_time IS 'Time used as reference time for the period search procedure in the segment [d]';
COMMENT ON COLUMN gaiadr3.vari_rotation_modulation.segments_g_chi_square IS 'Array of chisquares for linear models (G band)';
COMMENT ON COLUMN gaiadr3.vari_rotation_modulation.segments_bp_chi_square IS 'Array of chisquares for linear models (BP band)';
COMMENT ON COLUMN gaiadr3.vari_rotation_modulation.segments_rp_chi_square IS 'Array of chisquares for linear models (RP band)';
CREATE INDEX IF NOT EXISTS gaiadr3_vari_rotation_modulation_source_id_idx ON gaiadr3.vari_rotation_modulation (source_id);

-- [Variabilidad] gaiadr3.vari_rrlyrae — acceso: TAP Gaia (ADQL)
CREATE TABLE IF NOT EXISTS gaiadr3.vari_rrlyrae (
    solution_id bigint,
    source_id bigint,
    pf double precision,
    pf_error real,
    p1_o double precision,
    p1_o_error real,
    epoch_g double precision,
    epoch_g_error real,
    epoch_bp double precision,
    epoch_bp_error real,
    epoch_rp double precision,
    epoch_rp_error real,
    epoch_rv double precision,
    epoch_rv_error real,
    int_average_g real,
    int_average_g_error real,
    int_average_bp real,
    int_average_bp_error real,
    int_average_rp real,
    int_average_rp_error real,
    average_rv real,
    average_rv_error real,
    peak_to_peak_g real,
    peak_to_peak_g_error real,
    peak_to_peak_bp real,
    peak_to_peak_bp_error real,
    peak_to_peak_rp real,
    peak_to_peak_rp_error real,
    peak_to_peak_rv double precision,
    peak_to_peak_rv_error double precision,
    metallicity real,
    metallicity_error real,
    r21_g real,
    r21_g_error real,
    r31_g real,
    r31_g_error real,
    phi21_g real,
    phi21_g_error real,
    phi31_g real,
    phi31_g_error real,
    num_clean_epochs_g smallint,
    num_clean_epochs_bp smallint,
    num_clean_epochs_rp smallint,
    num_clean_epochs_rv smallint,
    zp_mag_g real,
    zp_mag_bp real,
    zp_mag_rp real,
    num_harmonics_for_p1_g smallint,
    num_harmonics_for_p1_bp smallint,
    num_harmonics_for_p1_rp smallint,
    num_harmonics_for_p1_rv smallint,
    reference_time_g double precision,
    reference_time_bp double precision,
    reference_time_rp double precision,
    reference_time_rv double precision,
    fund_freq1 double precision,
    fund_freq1_error real,
    fund_freq2 double precision,
    fund_freq2_error real,
    fund_freq1_harmonic_ampl_g real[],
    fund_freq1_harmonic_ampl_g_error real[],
    fund_freq1_harmonic_phase_g real[],
    fund_freq1_harmonic_phase_g_error real[],
    fund_freq1_harmonic_ampl_bp real[],
    fund_freq1_harmonic_ampl_bp_error real[],
    fund_freq1_harmonic_phase_bp real[],
    fund_freq1_harmonic_phase_bp_error real[],
    fund_freq1_harmonic_ampl_rp real[],
    fund_freq1_harmonic_ampl_rp_error real[],
    fund_freq1_harmonic_phase_rp real[],
    fund_freq1_harmonic_phase_rp_error real[],
    fund_freq1_harmonic_ampl_rv real[],
    fund_freq1_harmonic_ampl_rv_error real[],
    fund_freq1_harmonic_phase_rv real[],
    fund_freq1_harmonic_phase_rv_error real[],
    best_classification text,
    g_absorption real,
    g_absorption_error real
);
COMMENT ON TABLE gaiadr3.vari_rrlyrae IS 'This table describes the RR Lyrae stars.';
COMMENT ON COLUMN gaiadr3.vari_rrlyrae.solution_id IS 'Solution Identifier';
COMMENT ON COLUMN gaiadr3.vari_rrlyrae.source_id IS 'Unique source identifier';
COMMENT ON COLUMN gaiadr3.vari_rrlyrae.pf IS 'Period corresponding to the fundamental pulsation mode in the G band time series [d]';
COMMENT ON COLUMN gaiadr3.vari_rrlyrae.pf_error IS 'Uncertainty of the \texttt{pf} period [d]';
COMMENT ON COLUMN gaiadr3.vari_rrlyrae.p1_o IS 'Period corresponding to the first overtone pulsation mode in the G band time series [d]';
COMMENT ON COLUMN gaiadr3.vari_rrlyrae.p1_o_error IS 'Uncertainty of the \texttt{p1O} period [d]';
COMMENT ON COLUMN gaiadr3.vari_rrlyrae.epoch_g IS 'Epoch of the maximum of the light curve in the G band [d]';
COMMENT ON COLUMN gaiadr3.vari_rrlyrae.epoch_g_error IS 'Uncertainty on the epoch parameter \texttt{epochG} [d]';
COMMENT ON COLUMN gaiadr3.vari_rrlyrae.epoch_bp IS 'Epoch of the maximum of the light curve in the BP band [d]';
COMMENT ON COLUMN gaiadr3.vari_rrlyrae.epoch_bp_error IS 'Uncertainty on the epoch parameter \texttt{epochBp} [d]';
COMMENT ON COLUMN gaiadr3.vari_rrlyrae.epoch_rp IS 'Epoch of the maximum of the light curve in the RP band [d]';
COMMENT ON COLUMN gaiadr3.vari_rrlyrae.epoch_rp_error IS 'Uncertainty on the epoch parameter \texttt{epochRp} [d]';
COMMENT ON COLUMN gaiadr3.vari_rrlyrae.epoch_rv IS 'Epoch of the minimum of the radial velocity curve [d]';
COMMENT ON COLUMN gaiadr3.vari_rrlyrae.epoch_rv_error IS 'Uncertainty on the epoch parameter \texttt{epochRv} [d]';
COMMENT ON COLUMN gaiadr3.vari_rrlyrae.int_average_g IS 'Intensity-averaged magnitude in the G band [mag]';
COMMENT ON COLUMN gaiadr3.vari_rrlyrae.int_average_g_error IS 'Uncertainty on \texttt{intAverageG} parameter [mag]';
COMMENT ON COLUMN gaiadr3.vari_rrlyrae.int_average_bp IS 'Intensity-averaged magnitude in the BP band [mag]';
COMMENT ON COLUMN gaiadr3.vari_rrlyrae.int_average_bp_error IS 'Uncertainty on \texttt{intAverageBp} parameter [mag]';
COMMENT ON COLUMN gaiadr3.vari_rrlyrae.int_average_rp IS 'Intensity-averaged magnitude in the RP band [mag]';
COMMENT ON COLUMN gaiadr3.vari_rrlyrae.int_average_rp_error IS 'Uncertainty on \texttt{intAverageRp} parameter [mag]';
COMMENT ON COLUMN gaiadr3.vari_rrlyrae.average_rv IS 'Mean radial velocity [km.s**-1]';
COMMENT ON COLUMN gaiadr3.vari_rrlyrae.average_rv_error IS 'Uncertainty on \texttt{averageRv} parameter [km.s**-1]';
COMMENT ON COLUMN gaiadr3.vari_rrlyrae.peak_to_peak_g IS 'Peak-to-peak amplitude of the G band light curve [mag]';
COMMENT ON COLUMN gaiadr3.vari_rrlyrae.peak_to_peak_g_error IS 'Uncertainty on the \texttt{peakToPeakG} parameter [mag]';
COMMENT ON COLUMN gaiadr3.vari_rrlyrae.peak_to_peak_bp IS 'Peak-to-peak amplitude of the BP band light curve [mag]';
COMMENT ON COLUMN gaiadr3.vari_rrlyrae.peak_to_peak_bp_error IS 'Uncertainty on the \texttt{peakToPeakBp} parameter [mag]';
COMMENT ON COLUMN gaiadr3.vari_rrlyrae.peak_to_peak_rp IS 'Peak-to-peak amplitude of the RP band light curve [mag]';
COMMENT ON COLUMN gaiadr3.vari_rrlyrae.peak_to_peak_rp_error IS 'Uncertainty on the \texttt{peakToPeakRp} parameter [mag]';
COMMENT ON COLUMN gaiadr3.vari_rrlyrae.peak_to_peak_rv IS 'Peak-to-peak amplitude of the radial velocity curve [km.s**-1]';
COMMENT ON COLUMN gaiadr3.vari_rrlyrae.peak_to_peak_rv_error IS 'Uncertainty on the \texttt{peakToPeakRv} parameter [km.s**-1]';
COMMENT ON COLUMN gaiadr3.vari_rrlyrae.metallicity IS 'Metallicity of the star from the Fourier parameters of the light curve [''dex'']';
COMMENT ON COLUMN gaiadr3.vari_rrlyrae.metallicity_error IS 'Uncertainty of the \texttt{metallicity} parameter [''dex'']';
COMMENT ON COLUMN gaiadr3.vari_rrlyrae.r21_g IS 'Fourier decomposition parameter \texttt{r21G}: A2/A1 (for G band)';
COMMENT ON COLUMN gaiadr3.vari_rrlyrae.r21_g_error IS 'Uncertainty on the \texttt{r21G} parameter: A2/A1 (for G band)';
COMMENT ON COLUMN gaiadr3.vari_rrlyrae.r31_g IS 'Fourier decomposition parameter \texttt{r31G}: A3/A1 (for G band)';
COMMENT ON COLUMN gaiadr3.vari_rrlyrae.r31_g_error IS 'Uncertainty on the \texttt{r31G} parameter: A3/A1 (for G band)';
COMMENT ON COLUMN gaiadr3.vari_rrlyrae.phi21_g IS 'Fourier decomposition parameter \texttt{phi21G}: phi2 - 2*phi1 (for G band) [rad]';
COMMENT ON COLUMN gaiadr3.vari_rrlyrae.phi21_g_error IS 'Uncertainty on the \texttt{phi21G} parameter: phi2 - 2*phi1 (for G band) [rad]';
COMMENT ON COLUMN gaiadr3.vari_rrlyrae.phi31_g IS 'Fourier decomposition parameter \texttt{phi31G}: phi3 - 3*phi1 (for G band) [rad]';
COMMENT ON COLUMN gaiadr3.vari_rrlyrae.phi31_g_error IS 'Uncertainty on the \texttt{phi31G} parameter: phi3 - 3*phi1 (for G band) [rad]';
COMMENT ON COLUMN gaiadr3.vari_rrlyrae.num_clean_epochs_g IS 'Number of G FoV epochs used in the fitting algorithm';
COMMENT ON COLUMN gaiadr3.vari_rrlyrae.num_clean_epochs_bp IS 'Number of BP epochs used in the fitting algorithm';
COMMENT ON COLUMN gaiadr3.vari_rrlyrae.num_clean_epochs_rp IS 'Number of RP epochs used in the fitting algorithm';
COMMENT ON COLUMN gaiadr3.vari_rrlyrae.num_clean_epochs_rv IS 'Number of radial velocity epochs used in the fitting algorithm';
COMMENT ON COLUMN gaiadr3.vari_rrlyrae.zp_mag_g IS 'Zero point (mag) of the final model of the G band light curve [mag]';
COMMENT ON COLUMN gaiadr3.vari_rrlyrae.zp_mag_bp IS 'Zero point (mag) of the final model of the BP band light curve [mag]';
COMMENT ON COLUMN gaiadr3.vari_rrlyrae.zp_mag_rp IS 'Zero point (mag) of the final model of the RP band light curve [mag]';
COMMENT ON COLUMN gaiadr3.vari_rrlyrae.num_harmonics_for_p1_g IS 'Number of harmonics used to model the first periodicity of the G-band light curve';
COMMENT ON COLUMN gaiadr3.vari_rrlyrae.num_harmonics_for_p1_bp IS 'Number of harmonics used to model the first periodicity of the BP-band light curve';
COMMENT ON COLUMN gaiadr3.vari_rrlyrae.num_harmonics_for_p1_rp IS 'Number of harmonics used to model the first periodicity of the RP-band light curve';
COMMENT ON COLUMN gaiadr3.vari_rrlyrae.num_harmonics_for_p1_rv IS 'Number of harmonics used to model the first periodicity of the radial velocity curve';
COMMENT ON COLUMN gaiadr3.vari_rrlyrae.reference_time_g IS 'Reference time of the Fourier modelled G-band light curve [d]';
COMMENT ON COLUMN gaiadr3.vari_rrlyrae.reference_time_bp IS 'Reference time of the Fourier modelled BP-band light curve [d]';
COMMENT ON COLUMN gaiadr3.vari_rrlyrae.reference_time_rp IS 'Reference time of the Fourier modelled RP-band light curve [d]';
COMMENT ON COLUMN gaiadr3.vari_rrlyrae.reference_time_rv IS 'Reference time of the Fourier modelled radial velocity curve [d]';
COMMENT ON COLUMN gaiadr3.vari_rrlyrae.fund_freq1 IS 'First frequency of the non-linear Fourier modelling [d**-1]';
COMMENT ON COLUMN gaiadr3.vari_rrlyrae.fund_freq1_error IS 'Error of the first frequency of the non-linear Fourier modelling [d**-1]';
COMMENT ON COLUMN gaiadr3.vari_rrlyrae.fund_freq2 IS 'Second frequency of the non-linear Fourier modelling in the G band [d**-1]';
COMMENT ON COLUMN gaiadr3.vari_rrlyrae.fund_freq2_error IS 'Error of the second frequency of the non-linear Fourier modelling in the G band [d**-1]';
COMMENT ON COLUMN gaiadr3.vari_rrlyrae.fund_freq1_harmonic_ampl_g IS 'Amplitudes of the Fourier model for the first frequency in the G band [mag]';
COMMENT ON COLUMN gaiadr3.vari_rrlyrae.fund_freq1_harmonic_ampl_g_error IS 'Errors of the amplitudes of the Fourier model for the first frequency in the G band [mag]';
COMMENT ON COLUMN gaiadr3.vari_rrlyrae.fund_freq1_harmonic_phase_g IS 'Phases of the Fourier model for the first frequency in the G band [rad]';
COMMENT ON COLUMN gaiadr3.vari_rrlyrae.fund_freq1_harmonic_phase_g_error IS 'Errors of the phases of the Fourier model for the first frequency in the G band [rad]';
COMMENT ON COLUMN gaiadr3.vari_rrlyrae.fund_freq1_harmonic_ampl_bp IS 'Amplitudes of the Fourier model for the first frequency in the BP band [mag]';
COMMENT ON COLUMN gaiadr3.vari_rrlyrae.fund_freq1_harmonic_ampl_bp_error IS 'Errors of the amplitudes of the Fourier model for the first frequency in the BP band [mag]';
COMMENT ON COLUMN gaiadr3.vari_rrlyrae.fund_freq1_harmonic_phase_bp IS 'Phases of the Fourier model for the first frequency in the BP band [rad]';
COMMENT ON COLUMN gaiadr3.vari_rrlyrae.fund_freq1_harmonic_phase_bp_error IS 'Errors of the phases of the Fourier model for the first frequency in the BP band [rad]';
COMMENT ON COLUMN gaiadr3.vari_rrlyrae.fund_freq1_harmonic_ampl_rp IS 'Amplitudes of the Fourier model for the first frequency in the RP band [mag]';
COMMENT ON COLUMN gaiadr3.vari_rrlyrae.fund_freq1_harmonic_ampl_rp_error IS 'Errors of the amplitudes of the Fourier model for the first frequency in the RP band [mag]';
COMMENT ON COLUMN gaiadr3.vari_rrlyrae.fund_freq1_harmonic_phase_rp IS 'Phases of the Fourier model for the first frequency in the RP band [rad]';
COMMENT ON COLUMN gaiadr3.vari_rrlyrae.fund_freq1_harmonic_phase_rp_error IS 'Errors of the phases of the Fourier model for the first frequency in the RP band [rad]';
COMMENT ON COLUMN gaiadr3.vari_rrlyrae.fund_freq1_harmonic_ampl_rv IS 'Amplitudes of the Fourier model for the first frequency of the radial velocity curve [km.s**-1]';
COMMENT ON COLUMN gaiadr3.vari_rrlyrae.fund_freq1_harmonic_ampl_rv_error IS 'Errors of the amplitudes of the Fourier model for the first frequency of the radial velocity curve [km.s**-1]';
COMMENT ON COLUMN gaiadr3.vari_rrlyrae.fund_freq1_harmonic_phase_rv IS 'Phases of the Fourier model for the first frequency of the radial velocity curve [rad]';
COMMENT ON COLUMN gaiadr3.vari_rrlyrae.fund_freq1_harmonic_phase_rv_error IS 'Errors of the phases of the Fourier model for the first frequency of the radial velocity curve [rad]';
COMMENT ON COLUMN gaiadr3.vari_rrlyrae.best_classification IS 'Best RR Lyrae classification estimate out of: {`RRc, `RRab, `RRd}';
COMMENT ON COLUMN gaiadr3.vari_rrlyrae.g_absorption IS 'Interstellar absorption in the G-band [mag]';
COMMENT ON COLUMN gaiadr3.vari_rrlyrae.g_absorption_error IS 'Error on the interstellar absorption in the G-band [mag]';
CREATE INDEX IF NOT EXISTS gaiadr3_vari_rrlyrae_source_id_idx ON gaiadr3.vari_rrlyrae (source_id);

-- [Variabilidad] gaiadr3.vari_short_timescale — acceso: TAP Gaia (ADQL)
CREATE TABLE IF NOT EXISTS gaiadr3.vari_short_timescale (
    solution_id bigint,
    source_id bigint,
    amplitude_estimate real,
    number_of_fov_transits smallint,
    mean_of_fov_abbe_values real,
    variogram_num_points smallint,
    variogram_char_timescales real[],
    variogram_values double precision[],
    frequency double precision
);
COMMENT ON TABLE gaiadr3.vari_short_timescale IS 'This table describes the short-timescale sources.';
COMMENT ON COLUMN gaiadr3.vari_short_timescale.solution_id IS 'Solution Identifier';
COMMENT ON COLUMN gaiadr3.vari_short_timescale.source_id IS 'Unique source identifier';
COMMENT ON COLUMN gaiadr3.vari_short_timescale.amplitude_estimate IS 'Amplitude estimate of all per-CCD G-band photometry (95th quantile - 5th quantile) [mag]';
COMMENT ON COLUMN gaiadr3.vari_short_timescale.number_of_fov_transits IS 'Number of FoV transits with more than 7 CCD measurements after time series cleaning';
COMMENT ON COLUMN gaiadr3.vari_short_timescale.mean_of_fov_abbe_values IS 'Mean of per-FoV Abbe values derived from per-CCD G-band photometry';
COMMENT ON COLUMN gaiadr3.vari_short_timescale.variogram_num_points IS 'Number of selected timescale(s) derived from the variogram';
COMMENT ON COLUMN gaiadr3.vari_short_timescale.variogram_char_timescales IS 'Characteristic timescale(s) of variability [d]';
COMMENT ON COLUMN gaiadr3.vari_short_timescale.variogram_values IS 'Variogram values associated with the {\tt variogramCharTimescales} [mag**2]';
COMMENT ON COLUMN gaiadr3.vari_short_timescale.frequency IS 'Frequency search result for either G CCD, G FoV, BP or RP photometry [d**-1]';
CREATE INDEX IF NOT EXISTS gaiadr3_vari_short_timescale_source_id_idx ON gaiadr3.vari_short_timescale (source_id);

-- [Variabilidad] gaiadr3.vari_summary — acceso: TAP Gaia (ADQL)
CREATE TABLE IF NOT EXISTS gaiadr3.vari_summary (
    solution_id bigint,
    source_id bigint,
    num_selected_g_fov smallint,
    mean_obs_time_g_fov double precision,
    time_duration_g_fov real,
    min_mag_g_fov real,
    max_mag_g_fov real,
    mean_mag_g_fov real,
    median_mag_g_fov real,
    range_mag_g_fov real,
    trimmed_range_mag_g_fov real,
    std_dev_mag_g_fov real,
    skewness_mag_g_fov real,
    kurtosis_mag_g_fov real,
    mad_mag_g_fov real,
    abbe_mag_g_fov real,
    iqr_mag_g_fov real,
    stetson_mag_g_fov real,
    std_dev_over_rms_err_mag_g_fov real,
    outlier_median_g_fov real,
    num_selected_bp smallint,
    mean_obs_time_bp double precision,
    time_duration_bp real,
    min_mag_bp real,
    max_mag_bp real,
    mean_mag_bp real,
    median_mag_bp real,
    range_mag_bp real,
    trimmed_range_mag_bp real,
    std_dev_mag_bp real,
    skewness_mag_bp real,
    kurtosis_mag_bp real,
    mad_mag_bp real,
    abbe_mag_bp real,
    iqr_mag_bp real,
    stetson_mag_bp real,
    std_dev_over_rms_err_mag_bp real,
    outlier_median_bp real,
    num_selected_rp smallint,
    mean_obs_time_rp double precision,
    time_duration_rp real,
    min_mag_rp real,
    max_mag_rp real,
    mean_mag_rp real,
    median_mag_rp real,
    range_mag_rp real,
    trimmed_range_mag_rp real,
    std_dev_mag_rp real,
    skewness_mag_rp real,
    kurtosis_mag_rp real,
    mad_mag_rp real,
    abbe_mag_rp real,
    iqr_mag_rp real,
    stetson_mag_rp real,
    std_dev_over_rms_err_mag_rp real,
    outlier_median_rp real,
    in_vari_classification_result boolean,
    in_vari_rrlyrae boolean,
    in_vari_cepheid boolean,
    in_vari_planetary_transit boolean,
    in_vari_short_timescale boolean,
    in_vari_long_period_variable boolean,
    in_vari_eclipsing_binary boolean,
    in_vari_rotation_modulation boolean,
    in_vari_ms_oscillator boolean,
    in_vari_agn boolean,
    in_vari_microlensing boolean,
    in_vari_compact_companion boolean
);
COMMENT ON TABLE gaiadr3.vari_summary IS 'Summary table that provides the information on where a {\tt sourceId} can be found in the different {\tt Variability} tables and statistical parameters of time series, using only transits not rejected. Note that NULL is reported when the statistical parameter value is missing or cannot be calculated.';
COMMENT ON COLUMN gaiadr3.vari_summary.solution_id IS 'Solution Identifier';
COMMENT ON COLUMN gaiadr3.vari_summary.source_id IS 'Unique source identifier';
COMMENT ON COLUMN gaiadr3.vari_summary.num_selected_g_fov IS 'Total number of G FOV transits selected for variability analysis';
COMMENT ON COLUMN gaiadr3.vari_summary.mean_obs_time_g_fov IS 'Mean observation time for G FoV transits [d]';
COMMENT ON COLUMN gaiadr3.vari_summary.time_duration_g_fov IS 'Time duration of the time series for G FoV transits [d]';
COMMENT ON COLUMN gaiadr3.vari_summary.min_mag_g_fov IS 'Minimum G FoV magnitude [mag]';
COMMENT ON COLUMN gaiadr3.vari_summary.max_mag_g_fov IS 'Maximum G FoV magnitude [mag]';
COMMENT ON COLUMN gaiadr3.vari_summary.mean_mag_g_fov IS 'Mean G FoV magnitude [mag]';
COMMENT ON COLUMN gaiadr3.vari_summary.median_mag_g_fov IS 'Median G FoV magnitude [mag]';
COMMENT ON COLUMN gaiadr3.vari_summary.range_mag_g_fov IS 'Difference between the highest and lowest G FoV magnitudes [mag]';
COMMENT ON COLUMN gaiadr3.vari_summary.trimmed_range_mag_g_fov IS 'Trimmed difference between the highest and lowest G FoV magnitudes [mag]';
COMMENT ON COLUMN gaiadr3.vari_summary.std_dev_mag_g_fov IS 'Square root of the unweighted G FoV magnitude variance [mag]';
COMMENT ON COLUMN gaiadr3.vari_summary.skewness_mag_g_fov IS 'Standardized unweighted G FoV magnitude skewness';
COMMENT ON COLUMN gaiadr3.vari_summary.kurtosis_mag_g_fov IS 'Standardized unweighted G FoV magnitude kurtosis';
COMMENT ON COLUMN gaiadr3.vari_summary.mad_mag_g_fov IS 'Median Absolute Deviation (MAD) for G FoV transits [mag]';
COMMENT ON COLUMN gaiadr3.vari_summary.abbe_mag_g_fov IS 'Abbe value for G FoV transits';
COMMENT ON COLUMN gaiadr3.vari_summary.iqr_mag_g_fov IS 'Interquartile range for G FoV transits [mag]';
COMMENT ON COLUMN gaiadr3.vari_summary.stetson_mag_g_fov IS 'Stetson G FoV variability index';
COMMENT ON COLUMN gaiadr3.vari_summary.std_dev_over_rms_err_mag_g_fov IS 'Signal-to-Noise G FoV estimate';
COMMENT ON COLUMN gaiadr3.vari_summary.outlier_median_g_fov IS 'Greatest absolute deviation from the G FoV median normalized by the error';
COMMENT ON COLUMN gaiadr3.vari_summary.num_selected_bp IS 'Total number of BP observations selected for variability analysis';
COMMENT ON COLUMN gaiadr3.vari_summary.mean_obs_time_bp IS 'Mean observation time for BP observations [d]';
COMMENT ON COLUMN gaiadr3.vari_summary.time_duration_bp IS 'Time duration of the BP time series [d]';
COMMENT ON COLUMN gaiadr3.vari_summary.min_mag_bp IS 'Minimum BP magnitude [mag]';
COMMENT ON COLUMN gaiadr3.vari_summary.max_mag_bp IS 'Maximum BP magnitude [mag]';
COMMENT ON COLUMN gaiadr3.vari_summary.mean_mag_bp IS 'Mean BP magnitude [mag]';
COMMENT ON COLUMN gaiadr3.vari_summary.median_mag_bp IS 'Median BP magnitude [mag]';
COMMENT ON COLUMN gaiadr3.vari_summary.range_mag_bp IS 'Difference between the highest and lowest BP magnitudes [mag]';
COMMENT ON COLUMN gaiadr3.vari_summary.trimmed_range_mag_bp IS 'Trimmed difference between the highest and lowest BP magnitudes [mag]';
COMMENT ON COLUMN gaiadr3.vari_summary.std_dev_mag_bp IS 'Square root of the unweighted BP magnitude variance [mag]';
COMMENT ON COLUMN gaiadr3.vari_summary.skewness_mag_bp IS 'Standardized unweighted BP magnitude skewness';
COMMENT ON COLUMN gaiadr3.vari_summary.kurtosis_mag_bp IS 'Standardized unweighted BP magnitude kurtosis';
COMMENT ON COLUMN gaiadr3.vari_summary.mad_mag_bp IS 'Median Absolute Deviation (MAD) for BP observations [mag]';
COMMENT ON COLUMN gaiadr3.vari_summary.abbe_mag_bp IS 'Abbe value for BP observations';
COMMENT ON COLUMN gaiadr3.vari_summary.iqr_mag_bp IS 'Interquartile BP magnitude range [mag]';
COMMENT ON COLUMN gaiadr3.vari_summary.stetson_mag_bp IS 'Stetson BP variability index';
COMMENT ON COLUMN gaiadr3.vari_summary.std_dev_over_rms_err_mag_bp IS 'Signal-to-Noise BP estimate';
COMMENT ON COLUMN gaiadr3.vari_summary.outlier_median_bp IS 'Greatest absolute deviation from the BP median normalized by the error';
COMMENT ON COLUMN gaiadr3.vari_summary.num_selected_rp IS 'Total number of RP observations selected for variability analysis';
COMMENT ON COLUMN gaiadr3.vari_summary.mean_obs_time_rp IS 'Mean observation time for RP observations [d]';
COMMENT ON COLUMN gaiadr3.vari_summary.time_duration_rp IS 'Time duration of the RP time series [d]';
COMMENT ON COLUMN gaiadr3.vari_summary.min_mag_rp IS 'Minimum RP magnitude [mag]';
COMMENT ON COLUMN gaiadr3.vari_summary.max_mag_rp IS 'Maximum RP magnitude [mag]';
COMMENT ON COLUMN gaiadr3.vari_summary.mean_mag_rp IS 'Mean RP magnitude [mag]';
COMMENT ON COLUMN gaiadr3.vari_summary.median_mag_rp IS 'Median RP magnitude [mag]';
COMMENT ON COLUMN gaiadr3.vari_summary.range_mag_rp IS 'Difference between the highest and lowest RP magnitudes [mag]';
COMMENT ON COLUMN gaiadr3.vari_summary.trimmed_range_mag_rp IS 'Trimmed difference between the highest and lowest RP magnitudes [mag]';
COMMENT ON COLUMN gaiadr3.vari_summary.std_dev_mag_rp IS 'Square root of the unweighted RP magnitude variance [mag]';
COMMENT ON COLUMN gaiadr3.vari_summary.skewness_mag_rp IS 'Standardized unweighted RP magnitude skewness';
COMMENT ON COLUMN gaiadr3.vari_summary.kurtosis_mag_rp IS 'Standardized unweighted RP magnitude kurtosis';
COMMENT ON COLUMN gaiadr3.vari_summary.mad_mag_rp IS 'Median Absolute Deviation (MAD) for RP observations [mag]';
COMMENT ON COLUMN gaiadr3.vari_summary.abbe_mag_rp IS 'Abbe value for RP observations';
COMMENT ON COLUMN gaiadr3.vari_summary.iqr_mag_rp IS 'Interquartile RP magnitude range [mag]';
COMMENT ON COLUMN gaiadr3.vari_summary.stetson_mag_rp IS 'Stetson RP variability index';
COMMENT ON COLUMN gaiadr3.vari_summary.std_dev_over_rms_err_mag_rp IS 'Signal-to-Noise RP estimate';
COMMENT ON COLUMN gaiadr3.vari_summary.outlier_median_rp IS 'Greatest absolute deviation from the RP median normalized by the error';
COMMENT ON COLUMN gaiadr3.vari_summary.in_vari_classification_result IS 'Source is present in \texttt{VariClassifierResult}';
COMMENT ON COLUMN gaiadr3.vari_summary.in_vari_rrlyrae IS 'Source is present in \texttt{VariRrlyrae}';
COMMENT ON COLUMN gaiadr3.vari_summary.in_vari_cepheid IS 'Source is present in \texttt{VariCepheid}';
COMMENT ON COLUMN gaiadr3.vari_summary.in_vari_planetary_transit IS 'Source is present in \texttt{VariPlanetaryTransit}';
COMMENT ON COLUMN gaiadr3.vari_summary.in_vari_short_timescale IS 'Source is present in \texttt{VariShortTimescale}';
COMMENT ON COLUMN gaiadr3.vari_summary.in_vari_long_period_variable IS 'Source is present in \texttt{VariLongPeriodVariable}';
COMMENT ON COLUMN gaiadr3.vari_summary.in_vari_eclipsing_binary IS 'Source is present in \texttt{VariEclipsingBinary}';
COMMENT ON COLUMN gaiadr3.vari_summary.in_vari_rotation_modulation IS 'Source is present in \texttt{VariRotationModulation}';
COMMENT ON COLUMN gaiadr3.vari_summary.in_vari_ms_oscillator IS 'Source is present in \texttt{VariMsOscillator}';
COMMENT ON COLUMN gaiadr3.vari_summary.in_vari_agn IS 'Source is present in \texttt{VariAgn}';
COMMENT ON COLUMN gaiadr3.vari_summary.in_vari_microlensing IS 'Source is present in \texttt{VariMicrolensing}';
COMMENT ON COLUMN gaiadr3.vari_summary.in_vari_compact_companion IS 'Source is present in \texttt{VariCompactCompanion}';
CREATE INDEX IF NOT EXISTS gaiadr3_vari_summary_source_id_idx ON gaiadr3.vari_summary (source_id);

-- [Simulación] gaiadr3.gaia_source_simulation — acceso: TAP Gaia (ADQL)
CREATE TABLE IF NOT EXISTS gaiadr3.gaia_source_simulation (
    solution_id bigint,
    source_id bigint,
    ra double precision,
    ra_error real,
    dec double precision,
    dec_error real,
    parallax real,
    parallax_error real,
    pmra real,
    pmra_error real,
    pmdec real,
    pmdec_error real,
    n_obs_al integer,
    n_outliers_al integer,
    phot_g_mean_flux real,
    phot_g_mean_flux_error real,
    phot_g_mean_mag real,
    phot_bp_mean_flux real,
    phot_bp_mean_flux_error real,
    phot_bp_mean_mag real,
    phot_rp_mean_flux real,
    phot_rp_mean_flux_error real,
    phot_rp_mean_mag real,
    phot_rvs_mean_flux real,
    phot_rvs_mean_flux_error real,
    phot_rvs_mean_mag real,
    radial_velocity real,
    radial_velocity_error real,
    teff real,
    teff_error real,
    vsini real,
    vsini_error real,
    a0 real,
    a0_error real,
    feh real,
    feh_error real,
    logg real,
    logg_error real
);
COMMENT ON TABLE gaiadr3.gaia_source_simulation IS 'Table of sources realised according to the Gaia Object Generator (GOG) simulation. Observed attributes are given with simulated observational uncertainties. This table contains the output of GOG. The values are obtained after adding the corresponding uncertainty (based on the error models) to the true values in table GaiaUniverseModel. Both the values and the uncertainties are provided.';
COMMENT ON COLUMN gaiadr3.gaia_source_simulation.solution_id IS 'Solution Identifier';
COMMENT ON COLUMN gaiadr3.gaia_source_simulation.source_id IS 'Long Identifier';
COMMENT ON COLUMN gaiadr3.gaia_source_simulation.ra IS 'Right Ascension [deg]';
COMMENT ON COLUMN gaiadr3.gaia_source_simulation.ra_error IS 'Right Ascension error [mas]';
COMMENT ON COLUMN gaiadr3.gaia_source_simulation.dec IS 'Declination [deg]';
COMMENT ON COLUMN gaiadr3.gaia_source_simulation.dec_error IS 'Declination error [mas]';
COMMENT ON COLUMN gaiadr3.gaia_source_simulation.parallax IS 'Parallax [mas]';
COMMENT ON COLUMN gaiadr3.gaia_source_simulation.parallax_error IS 'Parallax error [mas]';
COMMENT ON COLUMN gaiadr3.gaia_source_simulation.pmra IS 'Proper motion in RA [mas.yr**-1]';
COMMENT ON COLUMN gaiadr3.gaia_source_simulation.pmra_error IS 'Error in RA proper motion [mas.yr**-1]';
COMMENT ON COLUMN gaiadr3.gaia_source_simulation.pmdec IS 'Proper motion in dec [mas.yr**-1]';
COMMENT ON COLUMN gaiadr3.gaia_source_simulation.pmdec_error IS 'Error in dec. proper motion [mas.yr**-1]';
COMMENT ON COLUMN gaiadr3.gaia_source_simulation.n_obs_al IS 'Number of AL observations';
COMMENT ON COLUMN gaiadr3.gaia_source_simulation.n_outliers_al IS 'Number of outliers AL observations';
COMMENT ON COLUMN gaiadr3.gaia_source_simulation.phot_g_mean_flux IS 'Mean G flux [''electron''.s**-1]';
COMMENT ON COLUMN gaiadr3.gaia_source_simulation.phot_g_mean_flux_error IS 'Mean G flux error [''electron''.s**-1]';
COMMENT ON COLUMN gaiadr3.gaia_source_simulation.phot_g_mean_mag IS 'Mean G magnitude [mag]';
COMMENT ON COLUMN gaiadr3.gaia_source_simulation.phot_bp_mean_flux IS 'Mean BP flux [''electron''.s**-1]';
COMMENT ON COLUMN gaiadr3.gaia_source_simulation.phot_bp_mean_flux_error IS 'Mean BP flux error [''electron''.s**-1]';
COMMENT ON COLUMN gaiadr3.gaia_source_simulation.phot_bp_mean_mag IS 'Mean BP magnitude [mag]';
COMMENT ON COLUMN gaiadr3.gaia_source_simulation.phot_rp_mean_flux IS 'Mean RP flux [''electron''.s**-1]';
COMMENT ON COLUMN gaiadr3.gaia_source_simulation.phot_rp_mean_flux_error IS 'Mean RP flux error [''electron''.s**-1]';
COMMENT ON COLUMN gaiadr3.gaia_source_simulation.phot_rp_mean_mag IS 'Mean RP magnitude [mag]';
COMMENT ON COLUMN gaiadr3.gaia_source_simulation.phot_rvs_mean_flux IS 'Mean RVS flux [''electron''.s**-1]';
COMMENT ON COLUMN gaiadr3.gaia_source_simulation.phot_rvs_mean_flux_error IS 'Mean RVS flux error [''electron''.s**-1]';
COMMENT ON COLUMN gaiadr3.gaia_source_simulation.phot_rvs_mean_mag IS 'Mean RVS magnitude [mag]';
COMMENT ON COLUMN gaiadr3.gaia_source_simulation.radial_velocity IS 'Radial velocity [km.s**-1]';
COMMENT ON COLUMN gaiadr3.gaia_source_simulation.radial_velocity_error IS 'Radial velocity error [km.s**-1]';
COMMENT ON COLUMN gaiadr3.gaia_source_simulation.teff IS 'Effective temperature [K]';
COMMENT ON COLUMN gaiadr3.gaia_source_simulation.teff_error IS 'Effective temperature error [K]';
COMMENT ON COLUMN gaiadr3.gaia_source_simulation.vsini IS 'v sin i [km.s**-1]';
COMMENT ON COLUMN gaiadr3.gaia_source_simulation.vsini_error IS 'v sin i error [km.s**-1]';
COMMENT ON COLUMN gaiadr3.gaia_source_simulation.a0 IS 'Extinction at 550 nm [mag]';
COMMENT ON COLUMN gaiadr3.gaia_source_simulation.a0_error IS 'Extinction at 550 nm error [mag]';
COMMENT ON COLUMN gaiadr3.gaia_source_simulation.feh IS 'Iron abundance [''dex'']';
COMMENT ON COLUMN gaiadr3.gaia_source_simulation.feh_error IS 'Iron abundance error [''dex'']';
COMMENT ON COLUMN gaiadr3.gaia_source_simulation.logg IS 'Surface gravity [log(cm.s**-2)]';
COMMENT ON COLUMN gaiadr3.gaia_source_simulation.logg_error IS 'Surface gravity Error [log(cm.s**-2)]';
CREATE INDEX IF NOT EXISTS gaiadr3_gaia_source_simulation_source_id_idx ON gaiadr3.gaia_source_simulation (source_id);

-- [Simulación] gaiadr3.gaia_universe_model — acceso: TAP Gaia (ADQL)
CREATE TABLE IF NOT EXISTS gaiadr3.gaia_universe_model (
    source_extended_id text,
    source_id bigint,
    solution_id bigint,
    ra double precision,
    dec double precision,
    barycentric_distance real,
    pmra real,
    pmdec real,
    radial_velocity real,
    mag_g real,
    mag_bp real,
    mag_rp real,
    mag_rvs real,
    v_i real,
    mean_absolute_v real,
    ag real,
    av real,
    teff real,
    spectral_type text,
    logg real,
    feh real,
    alphafe real,
    mbol real,
    age real,
    mass real,
    radius real,
    vsini real,
    population integer,
    has_photocenter_motion boolean,
    nc integer,
    nt integer,
    semimajor_axis real,
    eccentricity real,
    inclination real,
    longitude_ascending_node real,
    orbit_period real,
    periastron_date real,
    periastron_argument real,
    variability_type text,
    variability_amplitude real,
    variability_period real,
    variability_phase real,
    r_env_r_star real
);
COMMENT ON TABLE gaiadr3.gaia_universe_model IS 'Table of simulated galactic stars according to the Gaia Universal Model Simulation (GUMS). True values of the intrinsic simulated quantities (astrometry, photometry and physical parameters) for the sources generated by GOG using the Universe Model are given. No errors are added.';
COMMENT ON COLUMN gaiadr3.gaia_universe_model.source_extended_id IS 'Extended source identifier';
COMMENT ON COLUMN gaiadr3.gaia_universe_model.source_id IS 'Long Identifier';
COMMENT ON COLUMN gaiadr3.gaia_universe_model.solution_id IS 'Solution Identifier';
COMMENT ON COLUMN gaiadr3.gaia_universe_model.ra IS 'Right Ascension [deg]';
COMMENT ON COLUMN gaiadr3.gaia_universe_model.dec IS 'Declination [deg]';
COMMENT ON COLUMN gaiadr3.gaia_universe_model.barycentric_distance IS 'Barycentric distance to the simulated source [pc]';
COMMENT ON COLUMN gaiadr3.gaia_universe_model.pmra IS 'Proper motion along right ascension [mas.yr**-1]';
COMMENT ON COLUMN gaiadr3.gaia_universe_model.pmdec IS 'Proper motion along declination [mas.yr**-1]';
COMMENT ON COLUMN gaiadr3.gaia_universe_model.radial_velocity IS 'Radial Velocity [km.s**-1]';
COMMENT ON COLUMN gaiadr3.gaia_universe_model.mag_g IS 'Mean Apparent G magnitude [mag]';
COMMENT ON COLUMN gaiadr3.gaia_universe_model.mag_bp IS 'Mean Apparent BP magnitude [mag]';
COMMENT ON COLUMN gaiadr3.gaia_universe_model.mag_rp IS 'Mean Apparent RP magnitude [mag]';
COMMENT ON COLUMN gaiadr3.gaia_universe_model.mag_rvs IS 'Mean Apparent RVS magnitude [mag]';
COMMENT ON COLUMN gaiadr3.gaia_universe_model.v_i IS '(V-I) color [mag]';
COMMENT ON COLUMN gaiadr3.gaia_universe_model.mean_absolute_v IS 'Mean Absolute V magnitude [mag]';
COMMENT ON COLUMN gaiadr3.gaia_universe_model.ag IS 'Absorption in G [mag]';
COMMENT ON COLUMN gaiadr3.gaia_universe_model.av IS 'Absorption in V [mag]';
COMMENT ON COLUMN gaiadr3.gaia_universe_model.teff IS 'Effective temperature [K]';
COMMENT ON COLUMN gaiadr3.gaia_universe_model.spectral_type IS 'spectral class + luminosity class';
COMMENT ON COLUMN gaiadr3.gaia_universe_model.logg IS 'Surface gravity [log(cm.s**-2)]';
COMMENT ON COLUMN gaiadr3.gaia_universe_model.feh IS 'Metallicity [''dex'']';
COMMENT ON COLUMN gaiadr3.gaia_universe_model.alphafe IS 'Alpha elements [''dex'']';
COMMENT ON COLUMN gaiadr3.gaia_universe_model.mbol IS 'Absolute bolometric magnitude [mag]';
COMMENT ON COLUMN gaiadr3.gaia_universe_model.age IS 'Age [Gyr]';
COMMENT ON COLUMN gaiadr3.gaia_universe_model.mass IS 'Mass [solMass]';
COMMENT ON COLUMN gaiadr3.gaia_universe_model.radius IS 'Radius [solRad]';
COMMENT ON COLUMN gaiadr3.gaia_universe_model.vsini IS 'Rotational velocity [km.s**-1]';
COMMENT ON COLUMN gaiadr3.gaia_universe_model.population IS 'Population';
COMMENT ON COLUMN gaiadr3.gaia_universe_model.has_photocenter_motion IS 'Boolean describing if the photocenter has or not motion';
COMMENT ON COLUMN gaiadr3.gaia_universe_model.nc IS 'Number of components';
COMMENT ON COLUMN gaiadr3.gaia_universe_model.nt IS 'Total number of object';
COMMENT ON COLUMN gaiadr3.gaia_universe_model.semimajor_axis IS 'Semi major axis [AU]';
COMMENT ON COLUMN gaiadr3.gaia_universe_model.eccentricity IS 'Eccentricity';
COMMENT ON COLUMN gaiadr3.gaia_universe_model.inclination IS 'Inclination [deg]';
COMMENT ON COLUMN gaiadr3.gaia_universe_model.longitude_ascending_node IS 'Longitude of ascending node [deg]';
COMMENT ON COLUMN gaiadr3.gaia_universe_model.orbit_period IS 'Period of the orbit [d]';
COMMENT ON COLUMN gaiadr3.gaia_universe_model.periastron_date IS 'Date of periastron [d]';
COMMENT ON COLUMN gaiadr3.gaia_universe_model.periastron_argument IS 'Periastron argument [deg]';
COMMENT ON COLUMN gaiadr3.gaia_universe_model.variability_type IS 'Variability type';
COMMENT ON COLUMN gaiadr3.gaia_universe_model.variability_amplitude IS 'Amplitude of variability [mag]';
COMMENT ON COLUMN gaiadr3.gaia_universe_model.variability_period IS 'Period of variability [d]';
COMMENT ON COLUMN gaiadr3.gaia_universe_model.variability_phase IS 'Phase of variability';
COMMENT ON COLUMN gaiadr3.gaia_universe_model.r_env_r_star IS 'Envelope characterisic for Be stars';
CREATE INDEX IF NOT EXISTS gaiadr3_gaia_universe_model_source_id_idx ON gaiadr3.gaia_universe_model (source_id);

-- [Auxiliar] gaiadr3.commanded_scan_law — acceso: TAP Gaia (ADQL)
CREATE TABLE IF NOT EXISTS gaiadr3.commanded_scan_law (
    jd_time double precision,
    bjd_fov1 double precision,
    bjd_fov2 double precision,
    obmt_time bigint,
    ra_fov1 real,
    dec_fov1 real,
    heal_pix_fov1 integer,
    scan_angle_fov1 real,
    ra_fov2 real,
    dec_fov2 real,
    heal_pix_fov2 integer,
    scan_angle_fov2 real,
    solution_id bigint
);
COMMENT ON TABLE gaiadr3.commanded_scan_law IS 'This table provides a representation of the Gaia scanning law over the 34 month time period covered by the Gaia Data Release 3 (from 2014-07-25 10:31:26 to 2017-05-28 08:46:29), including the Ecliptic Pole Scanning at the begin of the mission. Note that this is the commanded attitude of the spacecraft, the actual attitude could deviate from it by up to about 30 arcsec. Also, it does not contain any of the data interruptions that occurred during the real mission, of which the main ones are listed in Chapter [chap:cu0int], Section [cu0int_sec:release_framework]. The scanning law has been sampled at a 10 second interval, in which the satellite rotates about 10 arcminutes (the target spin rate is actually 59.9641857803 arcsec/sec). Note that this is several times shorter than a typical field-of-view transit and the scan position angle will be practically constant during this interval. Notes: - The times in columns 1, 2 and 3 are in Julian days in TCB with time origin 2010-01-01T00:00 (JD 2455197.5), following the time coordinate convention used in the Gaia archive. TCB stands for Barycentric Coordinate Time and is the time standard used in Gaia processing, equivalent to the proper time experienced by a clock at rest in a coordinate frame co-moving with the barycentre of the Solar system but outside its gravity well, therefore not influenced by the gravitational time dilation caused by the Sun and the rest of the solar system. - Column 1 is the reference time for the spacecraft attitude, while columns 2 and 3 give the times with the (relativistic) corrections applied for the light-travel time to the solar system barycentre, corresponding to an infinitely distant source at the RA, DEC at the centres of FOV 1 and 2, respectively. - FOV1 and FOV2 correspond to the preceding (PFOV) and following (FFOV) fields-of-view, respectively. - The centres of the field of views are separated by the basic angle of 106.5 deg, see Fig. 2 of . Their origin in the focal plane is illustrated in Fig. 3 of the same paper: both originate in the astrometric field (AF) 7, with FOV1 in row 3 and FOV2 in row 5. - The scan angle, theta, is the position angle of the direction in which the FOV is moving (also called ‘along-scan’ direction), and is defined in the usual astronomical sense: theta = 0 when the FoV is moving towards local North, and theta = 90 degrees towards local East. - All values have been formatted to the default double numerical precision and so this precision should not be interpreted as the accuracy of the data.';
COMMENT ON COLUMN gaiadr3.commanded_scan_law.jd_time IS 'Time [Julian Date in TCB at Gaia - 2455197.5] [d]';
COMMENT ON COLUMN gaiadr3.commanded_scan_law.bjd_fov1 IS 'Time [Julian Date in TCB at barycentre for FOV1 - 2455197.5] [d]';
COMMENT ON COLUMN gaiadr3.commanded_scan_law.bjd_fov2 IS 'Time [Julian Date in TCB at barycentre for FOV2 - 2455197.5] [d]';
COMMENT ON COLUMN gaiadr3.commanded_scan_law.obmt_time IS 'Time at Gaia (OBMT) [ns]';
COMMENT ON COLUMN gaiadr3.commanded_scan_law.ra_fov1 IS 'Right Ascension of FOV1 centre [deg]';
COMMENT ON COLUMN gaiadr3.commanded_scan_law.dec_fov1 IS 'Declination of FOV1 centre [deg]';
COMMENT ON COLUMN gaiadr3.commanded_scan_law.heal_pix_fov1 IS 'FOV1 HEALPix level 12';
COMMENT ON COLUMN gaiadr3.commanded_scan_law.scan_angle_fov1 IS 'Scan position angle of FOV1 [deg]';
COMMENT ON COLUMN gaiadr3.commanded_scan_law.ra_fov2 IS 'Right ascension of FOV2 centre [deg]';
COMMENT ON COLUMN gaiadr3.commanded_scan_law.dec_fov2 IS 'Declination of FOV2 centre [deg]';
COMMENT ON COLUMN gaiadr3.commanded_scan_law.heal_pix_fov2 IS 'FOV2 HEALPix level 12';
COMMENT ON COLUMN gaiadr3.commanded_scan_law.scan_angle_fov2 IS 'Scan position angle of FOV2 [deg]';
COMMENT ON COLUMN gaiadr3.commanded_scan_law.solution_id IS 'Solution Identifier';

-- [SPHEREx: tablas TAP de IRSA] spherex.artifact — acceso: TAP IRSA (ADQL)
CREATE TABLE IF NOT EXISTS spherex.artifact (
    planeid text,
    artifactid text,
    uri text,
    producttype text,
    releasetype text,
    contenttype text,
    contentlength bigint,
    contentchecksum text,
    ipac_gid integer,
    mission_id integer,
    ipac_pub_date text,
    lastmodified text
);
COMMENT ON TABLE spherex.artifact IS 'SPHEREx CAOM Artifact Table';
COMMENT ON COLUMN spherex.artifact.planeid IS 'foreign key: caom.plane.planeid';
COMMENT ON COLUMN spherex.artifact.artifactid IS 'unique artifact identifier: 32-bit UUID';
COMMENT ON COLUMN spherex.artifact.uri IS 'artifact access url';
COMMENT ON COLUMN spherex.artifact.producttype IS 'product type (e.g. science, calibration, auxiliary, preview, info)';
COMMENT ON COLUMN spherex.artifact.releasetype IS 'release type (data, meta)';
COMMENT ON COLUMN spherex.artifact.contenttype IS 'artifact file type';
COMMENT ON COLUMN spherex.artifact.contentlength IS 'artifact size in bytes [byte]';
COMMENT ON COLUMN spherex.artifact.contentchecksum IS 'checksum of the content (URI of the form {algorithm}:{hex value})';
COMMENT ON COLUMN spherex.artifact.ipac_gid IS 'IRSA access control identifier: group ID';
COMMENT ON COLUMN spherex.artifact.mission_id IS 'IRSA access control identifier: mission ID';
COMMENT ON COLUMN spherex.artifact.ipac_pub_date IS 'public release date (UTC)';
COMMENT ON COLUMN spherex.artifact.lastmodified IS 'timestamp of last modification of this row';

-- [SPHEREx: tablas TAP de IRSA] spherex.obscore — acceso: TAP IRSA (ADQL)
CREATE TABLE IF NOT EXISTS spherex.obscore (
    obs_id text,
    obs_collection text,
    s_ra double precision,
    s_dec double precision,
    energy_bandpassname text,
    em_min double precision,
    em_max double precision,
    t_min double precision,
    t_max double precision,
    t_exptime double precision,
    access_url text,
    access_format text,
    dataproduct_type text,
    calib_level smallint,
    target_name text,
    obs_title text,
    facility_name text,
    instrument_name text,
    obs_creation_date text,
    obs_creator_name text,
    obs_release_date text,
    obs_publisher_did text,
    publisher_id text,
    bib_reference text,
    data_rights text,
    s_fov double precision,
    s_region text,
    s_resolution double precision,
    s_xel1 bigint,
    s_xel2 bigint,
    s_ucd text,
    s_unit text,
    s_resolution_min double precision,
    s_resolution_max double precision,
    s_calib_status text,
    s_pixel_scale double precision,
    t_xel bigint,
    t_resolution double precision,
    em_xel bigint,
    em_calib_status text,
    em_res_power double precision,
    pol_xel bigint,
    proposal_id text,
    energy_emband text,
    position_timedependent boolean,
    obs_intent text,
    algorithm_name text,
    facility_keywords text,
    instrument_keywords text,
    environment_photometric boolean,
    proposal_project text,
    target_type text,
    target_standard boolean,
    target_moving boolean,
    target_keywords text,
    proposal_pi text,
    access_estsize bigint,
    o_ucd text,
    ipac_gid integer,
    ipac_pub_date text,
    pt text,
    poly text
);
COMMENT ON TABLE spherex.obscore IS 'IRSA ObsCore table of SPHEREx products';
COMMENT ON COLUMN spherex.obscore.obs_id IS 'Observation ID';
COMMENT ON COLUMN spherex.obscore.obs_collection IS 'Data collection';
COMMENT ON COLUMN spherex.obscore.s_ra IS 'Central right ascension, ICRS [deg]';
COMMENT ON COLUMN spherex.obscore.s_dec IS 'Central declination, ICRS [deg]';
COMMENT ON COLUMN spherex.obscore.energy_bandpassname IS 'Band name';
COMMENT ON COLUMN spherex.obscore.em_min IS 'Minimum wavelength (in meters) [m]';
COMMENT ON COLUMN spherex.obscore.em_max IS 'Maximum wavelength (in meters) [m]';
COMMENT ON COLUMN spherex.obscore.t_min IS 'Observation start time (in MJD) [d]';
COMMENT ON COLUMN spherex.obscore.t_max IS 'Observation end time (in MJD) [d]';
COMMENT ON COLUMN spherex.obscore.t_exptime IS 'Exposure time [s]';
COMMENT ON COLUMN spherex.obscore.access_url IS 'Data access URL';
COMMENT ON COLUMN spherex.obscore.access_format IS 'MIME type of access_url';
COMMENT ON COLUMN spherex.obscore.dataproduct_type IS 'Data product type (e.g. image, spectrum, cube, measurements)';
COMMENT ON COLUMN spherex.obscore.calib_level IS 'Calibration level (0, 1, 2, 3, 4)';
COMMENT ON COLUMN spherex.obscore.target_name IS 'SPHEREx target field';
COMMENT ON COLUMN spherex.obscore.obs_title IS 'Description of observation';
COMMENT ON COLUMN spherex.obscore.facility_name IS 'Telescope name';
COMMENT ON COLUMN spherex.obscore.instrument_name IS 'Instrument name';
COMMENT ON COLUMN spherex.obscore.obs_creation_date IS 'Data product creation date';
COMMENT ON COLUMN spherex.obscore.obs_creator_name IS 'Data product creator';
COMMENT ON COLUMN spherex.obscore.obs_release_date IS 'Public release date';
COMMENT ON COLUMN spherex.obscore.obs_publisher_did IS 'IVOA ID for the dataset, assigned by the publisher (IRSA)';
COMMENT ON COLUMN spherex.obscore.publisher_id IS 'IVOA ID for the publisher (IRSA)';
COMMENT ON COLUMN spherex.obscore.bib_reference IS 'IRSA documentation landing page';
COMMENT ON COLUMN spherex.obscore.data_rights IS 'Data rights (Public, Secure, Proprietary)';
COMMENT ON COLUMN spherex.obscore.s_fov IS 'Field of view [deg]';
COMMENT ON COLUMN spherex.obscore.s_region IS 'Sky region covered by the data product (ICRS)';
COMMENT ON COLUMN spherex.obscore.s_resolution IS 'Spatial resolution [arcsec]';
COMMENT ON COLUMN spherex.obscore.s_xel1 IS 'Number of pixels along x-axis (NAXIS1)';
COMMENT ON COLUMN spherex.obscore.s_xel2 IS 'Number of pixels along y-axis (NAXIS2)';
COMMENT ON COLUMN spherex.obscore.s_ucd IS 'UCD for s_xel1/s_xel2 (pos or u,v data)';
COMMENT ON COLUMN spherex.obscore.s_unit IS 'Units used for s_ra, s_dec';
COMMENT ON COLUMN spherex.obscore.s_resolution_min IS 'Minimum spatial resolution [arcsec]';
COMMENT ON COLUMN spherex.obscore.s_resolution_max IS 'Maximum spatial resolution [arcsec]';
COMMENT ON COLUMN spherex.obscore.s_calib_status IS 'Astrometric calibration status';
COMMENT ON COLUMN spherex.obscore.s_pixel_scale IS 'Pixel size [arcsec]';
COMMENT ON COLUMN spherex.obscore.t_xel IS 'Number of pixels along the time axis';
COMMENT ON COLUMN spherex.obscore.t_resolution IS 'Resolution on the time axis [s]';
COMMENT ON COLUMN spherex.obscore.em_xel IS 'Number of pixels along the energy axis';
COMMENT ON COLUMN spherex.obscore.em_calib_status IS 'Type of spectral coord calibration';
COMMENT ON COLUMN spherex.obscore.em_res_power IS 'Spectral resolving power (R)';
COMMENT ON COLUMN spherex.obscore.pol_xel IS 'Number of pixels along the polarization axis';
COMMENT ON COLUMN spherex.obscore.proposal_id IS 'Proposal identifier';
COMMENT ON COLUMN spherex.obscore.energy_emband IS 'Energy band (Radio,Millimeter,Infrared,Optical,...)';
COMMENT ON COLUMN spherex.obscore.position_timedependent IS 'Position is time-dependent (0=false, 1=true)';
COMMENT ON COLUMN spherex.obscore.obs_intent IS 'Intended purpose of data (science, calibration)';
COMMENT ON COLUMN spherex.obscore.algorithm_name IS 'Algorithm (e.g. mosaic, exposure)';
COMMENT ON COLUMN spherex.obscore.facility_keywords IS 'Telescope keywords formatted as a JSON string';
COMMENT ON COLUMN spherex.obscore.instrument_keywords IS 'Instrument keywords formatted as a JSON string';
COMMENT ON COLUMN spherex.obscore.environment_photometric IS 'Conditions were photometric (0=false, 1=true)';
COMMENT ON COLUMN spherex.obscore.proposal_project IS 'Project that created/acquired the observation';
COMMENT ON COLUMN spherex.obscore.target_type IS 'Classification of intended target (object, field)';
COMMENT ON COLUMN spherex.obscore.target_standard IS 'Intended target is a standard (0=false, 1=true)';
COMMENT ON COLUMN spherex.obscore.target_moving IS 'Intended target is moving (0=false, 1=true)';
COMMENT ON COLUMN spherex.obscore.target_keywords IS 'Target keywords formatted as a JSON string';
COMMENT ON COLUMN spherex.obscore.proposal_pi IS 'Proposal principal investigator';
COMMENT ON COLUMN spherex.obscore.access_estsize IS 'Estimated size of the download at access_url [kbyte]';
COMMENT ON COLUMN spherex.obscore.o_ucd IS 'UCD of the observable (e.g. phot.flux.density, phot.count)';
COMMENT ON COLUMN spherex.obscore.ipac_gid IS 'Internal IRSA column: group ID';
COMMENT ON COLUMN spherex.obscore.ipac_pub_date IS 'Internal IRSA column: public release date';
COMMENT ON COLUMN spherex.obscore.pt IS 'Internal IRSA column: Spatial index [deg]';
COMMENT ON COLUMN spherex.obscore.poly IS 'Internal IRSA column: Spatial index [deg]';
CREATE INDEX IF NOT EXISTS spherex_obscore_obs_publisher_did_idx ON spherex.obscore (obs_publisher_did);

-- [SPHEREx: tablas TAP de IRSA] spherex.observation — acceso: TAP IRSA (ADQL)
CREATE TABLE IF NOT EXISTS spherex.observation (
    obsid text,
    collection text,
    observationid text,
    metarelease text,
    sequencenumber integer,
    type text,
    intent text,
    algorithm_name text,
    telescope_name text,
    telescope_geolocationx double precision,
    telescope_geolocationy double precision,
    telescope_geolocationz double precision,
    telescope_keywords text,
    instrument_name text,
    instrument_keywords text,
    environment_seeing double precision,
    environment_humidity double precision,
    environment_elevation double precision,
    environment_tau double precision,
    environment_wavelengthtau double precision,
    environment_ambienttemp double precision,
    environment_photometric boolean,
    proposal_id text,
    proposal_pi text,
    proposal_project text,
    proposal_title text,
    proposal_keywords text,
    target_name text,
    target_type text,
    target_redshift double precision,
    target_standard boolean,
    target_moving boolean,
    target_keywords text,
    targetposition_coordinates text,
    targetposition_coordsys text,
    targetposition_equinox double precision,
    requirements_flag text,
    ipac_gid integer,
    mission_id integer,
    ipac_pub_date text,
    lastmodified text
);
COMMENT ON TABLE spherex.observation IS 'SPHEREx CAOM Observation Table';
COMMENT ON COLUMN spherex.observation.obsid IS 'unique observation identifier: 32-bit UUID';
COMMENT ON COLUMN spherex.observation.collection IS 'data collection this observation belongs to';
COMMENT ON COLUMN spherex.observation.observationid IS 'unique observation identifier (human readable)';
COMMENT ON COLUMN spherex.observation.metarelease IS 'metadata public release date';
COMMENT ON COLUMN spherex.observation.sequencenumber IS 'sequence number of the observation';
COMMENT ON COLUMN spherex.observation.type IS 'type of data, often from FITS OBSTYPE keyword, e.g. exposure, spectrum, object, dark';
COMMENT ON COLUMN spherex.observation.intent IS 'intended purpose of data (one of: science, calibration)';
COMMENT ON COLUMN spherex.observation.algorithm_name IS 'algorithm that defines the observation (e.g. exposure, coadd, cube)';
COMMENT ON COLUMN spherex.observation.telescope_name IS 'name of telescope used to acquire observation';
COMMENT ON COLUMN spherex.observation.telescope_geolocationx IS 'x component of geocentric location of telescope';
COMMENT ON COLUMN spherex.observation.telescope_geolocationy IS 'y component of geocentric location of telescope';
COMMENT ON COLUMN spherex.observation.telescope_geolocationz IS 'z component of geocentric location of telescope';
COMMENT ON COLUMN spherex.observation.telescope_keywords IS 'telescope keywords (JSON of key/value pairs)';
COMMENT ON COLUMN spherex.observation.instrument_name IS 'name of instrument used to acquire observation';
COMMENT ON COLUMN spherex.observation.instrument_keywords IS 'instrument keywords (JSON of key/value pairs)';
COMMENT ON COLUMN spherex.observation.environment_seeing IS 'atmospheric seeing (FWHM) [arcsec]';
COMMENT ON COLUMN spherex.observation.environment_humidity IS 'humidity at telescope during observation';
COMMENT ON COLUMN spherex.observation.environment_elevation IS 'elevation above horizon (0 to 90) [deg]';
COMMENT ON COLUMN spherex.observation.environment_tau IS 'zenith optical depth';
COMMENT ON COLUMN spherex.observation.environment_wavelengthtau IS 'wavelength at which Tau has been measured [m]';
COMMENT ON COLUMN spherex.observation.environment_ambienttemp IS 'ambient temperature telescope during observation [C]';
COMMENT ON COLUMN spherex.observation.environment_photometric IS 'conditions were photometric (0=false, 1=true)';
COMMENT ON COLUMN spherex.observation.proposal_id IS 'collection-specific unique proposal identifier';
COMMENT ON COLUMN spherex.observation.proposal_pi IS 'proposal principal investigator';
COMMENT ON COLUMN spherex.observation.proposal_project IS 'project that created/acquired the observation';
COMMENT ON COLUMN spherex.observation.proposal_title IS 'proposal title';
COMMENT ON COLUMN spherex.observation.proposal_keywords IS 'proposal keywords (JSON of key/value pairs)';
COMMENT ON COLUMN spherex.observation.target_name IS 'name of intended target';
COMMENT ON COLUMN spherex.observation.target_type IS 'classification of intended target';
COMMENT ON COLUMN spherex.observation.target_redshift IS 'redshift of intended target';
COMMENT ON COLUMN spherex.observation.target_standard IS 'intended target is a standard (0=false, 1=true)';
COMMENT ON COLUMN spherex.observation.target_moving IS 'flag for moving target';
COMMENT ON COLUMN spherex.observation.target_keywords IS 'target keywords (JSON of key/value pairs)';
COMMENT ON COLUMN spherex.observation.targetposition_coordinates IS 'coordiantes of the target position [deg]';
COMMENT ON COLUMN spherex.observation.targetposition_coordsys IS 'coordinate system for target position';
COMMENT ON COLUMN spherex.observation.targetposition_equinox IS 'equinox of target position coordinate system';
COMMENT ON COLUMN spherex.observation.requirements_flag IS 'flag describing satisfied proposal requirements (possible values: fail,null)';
COMMENT ON COLUMN spherex.observation.ipac_gid IS 'IRSA access control identifier: group ID';
COMMENT ON COLUMN spherex.observation.mission_id IS 'IRSA access control identifier: mission ID';
COMMENT ON COLUMN spherex.observation.ipac_pub_date IS 'public release date (UTC)';
COMMENT ON COLUMN spherex.observation.lastmodified IS 'timestamp of last modification of this row';

-- [SPHEREx: tablas TAP de IRSA] spherex.plane — acceso: TAP IRSA (ADQL)
CREATE TABLE IF NOT EXISTS spherex.plane (
    obsid text,
    planeid text,
    productid text,
    creatorid text,
    metarelease text,
    datarelease text,
    calibrationlevel smallint,
    dataproducttype text,
    quality_flag text,
    metrics_sourcenumberdensity double precision,
    metrics_background double precision,
    metrics_backgroundstddev double precision,
    metrics_fluxdensitylimit double precision,
    metrics_maglimit double precision,
    position_dimension_naxis1 bigint,
    position_dimension_naxis2 bigint,
    position_resolution double precision,
    position_samplesize double precision,
    position_timedependent boolean,
    energy_bounds_lower double precision,
    energy_bounds_upper double precision,
    energy_bounds_samples double precision,
    energy_emband text,
    energy_dimension bigint,
    energy_resolvingpower double precision,
    energy_samplesize double precision,
    energy_bandpassname text,
    energy_transition_species text,
    energy_transition_transition text,
    energy_restwav double precision,
    time_bounds_lower double precision,
    time_bounds_upper double precision,
    time_bounds_samples double precision,
    time_dimension bigint,
    time_resolution double precision,
    time_samplesize double precision,
    time_exposure double precision,
    polarization_states text,
    polarization_dimension bigint,
    provenance_name text,
    provenance_reference text,
    provenance_version text,
    provenance_project text,
    provenance_producer text,
    provenance_runid text,
    provenance_lastexecuted text,
    provenance_keywords text,
    ipac_gid integer,
    mission_id integer,
    poly text,
    pt text,
    ipac_pub_date text,
    lastmodified text,
    obs_publisher_did text
);
COMMENT ON TABLE spherex.plane IS 'SPHEREx CAOM Plane Table';
COMMENT ON COLUMN spherex.plane.obsid IS 'foreign key: caom.observation.obsid';
COMMENT ON COLUMN spherex.plane.planeid IS 'unique plane identifier: 32-bit UUID';
COMMENT ON COLUMN spherex.plane.productid IS 'name of this product';
COMMENT ON COLUMN spherex.plane.creatorid IS 'unique creator identifier for this product';
COMMENT ON COLUMN spherex.plane.metarelease IS 'date the metadata for a plane is public (UTC)';
COMMENT ON COLUMN spherex.plane.datarelease IS 'public release date';
COMMENT ON COLUMN spherex.plane.calibrationlevel IS 'IVOA ObsCore calibration level (-1,0,1,2,3,4)';
COMMENT ON COLUMN spherex.plane.dataproducttype IS 'IVOA ObsCore data product type + extensions';
COMMENT ON COLUMN spherex.plane.quality_flag IS 'flag describing the data quality';
COMMENT ON COLUMN spherex.plane.metrics_sourcenumberdensity IS 'number density of sources [deg-2]';
COMMENT ON COLUMN spherex.plane.metrics_background IS 'background intensity [Jy/pix]';
COMMENT ON COLUMN spherex.plane.metrics_backgroundstddev IS 'standard deviation in background [Jy/pix]';
COMMENT ON COLUMN spherex.plane.metrics_fluxdensitylimit IS 'flux density limit where S:N=5 for point source [Jy]';
COMMENT ON COLUMN spherex.plane.metrics_maglimit IS 'AB magnitude limit where S:N=5 for point source';
COMMENT ON COLUMN spherex.plane.position_dimension_naxis1 IS 'dimensions (number of pixels) along one spatial axis';
COMMENT ON COLUMN spherex.plane.position_dimension_naxis2 IS 'dimensions (number of pixels) along other spatial axis';
COMMENT ON COLUMN spherex.plane.position_resolution IS 'median spatial resolution (FWHM) [arcsec]';
COMMENT ON COLUMN spherex.plane.position_samplesize IS 'median sample (pixel) size on spatial axes [arcsec]';
COMMENT ON COLUMN spherex.plane.position_timedependent IS 'flag indicating that the position is time-dependent (0=false, 1=true)';
COMMENT ON COLUMN spherex.plane.energy_bounds_lower IS 'lower bound on energy axis (barycentric wavelength) [m]';
COMMENT ON COLUMN spherex.plane.energy_bounds_upper IS 'upper bound on energy axis (barycentric wavelength) [m]';
COMMENT ON COLUMN spherex.plane.energy_bounds_samples IS 'detailed energy coverage (barycentric wavelength) [m]';
COMMENT ON COLUMN spherex.plane.energy_emband IS 'comma-separated energy band names (e.g. Infrared, Optical)';
COMMENT ON COLUMN spherex.plane.energy_dimension IS 'dimension (number of pixels) along energy axis';
COMMENT ON COLUMN spherex.plane.energy_resolvingpower IS 'median spectral resolving power (R)';
COMMENT ON COLUMN spherex.plane.energy_samplesize IS 'median sample (pixel) size on energy axis [m]';
COMMENT ON COLUMN spherex.plane.energy_bandpassname IS 'collection-specific name for energy band (e.g. filter name)';
COMMENT ON COLUMN spherex.plane.energy_transition_species IS 'atom or molecule';
COMMENT ON COLUMN spherex.plane.energy_transition_transition IS 'specific energy transition of species';
COMMENT ON COLUMN spherex.plane.energy_restwav IS 'rest wavelength of target spectral feature (barycentric) [m]';
COMMENT ON COLUMN spherex.plane.time_bounds_lower IS 'lower bound on time axis (Modified Julian Day) [d]';
COMMENT ON COLUMN spherex.plane.time_bounds_upper IS 'upper bound on time axis (Modified Julian Day) [d]';
COMMENT ON COLUMN spherex.plane.time_bounds_samples IS 'detailed time coverage (Modified Julian Day) [d]';
COMMENT ON COLUMN spherex.plane.time_dimension IS 'dimension (number of pixels) along time axis';
COMMENT ON COLUMN spherex.plane.time_resolution IS 'median resolution on the time axis [d]';
COMMENT ON COLUMN spherex.plane.time_samplesize IS 'median sample (pixel) size on time axis [d]';
COMMENT ON COLUMN spherex.plane.time_exposure IS 'median exposure time per pixel [s]';
COMMENT ON COLUMN spherex.plane.polarization_states IS 'polarization letter codes - not populated at IRSA';
COMMENT ON COLUMN spherex.plane.polarization_dimension IS 'number of samples (pixels) along polarization axis';
COMMENT ON COLUMN spherex.plane.provenance_name IS 'name of the process that created this plane';
COMMENT ON COLUMN spherex.plane.provenance_reference IS 'external reference (URL)';
COMMENT ON COLUMN spherex.plane.provenance_version IS 'version of the process/software';
COMMENT ON COLUMN spherex.plane.provenance_project IS 'responsible entity (e.g. person)';
COMMENT ON COLUMN spherex.plane.provenance_producer IS 'responsible entity (e.g. person)';
COMMENT ON COLUMN spherex.plane.provenance_runid IS 'responsible entity (e.g. person)';
COMMENT ON COLUMN spherex.plane.provenance_lastexecuted IS 'date this process was last executed';
COMMENT ON COLUMN spherex.plane.provenance_keywords IS 'provenance keywords (JSON of key/value pairs)';
COMMENT ON COLUMN spherex.plane.ipac_gid IS 'IRSA access control identifier: group ID';
COMMENT ON COLUMN spherex.plane.mission_id IS 'IRSA access control identifier: mission ID';
COMMENT ON COLUMN spherex.plane.poly IS 'IRSA internal spatial index descriptor [deg]';
COMMENT ON COLUMN spherex.plane.pt IS 'IRSA internal spatial index descriptor [deg]';
COMMENT ON COLUMN spherex.plane.ipac_pub_date IS 'public release date (UTC)';
COMMENT ON COLUMN spherex.plane.lastmodified IS 'timestamp of last modification of this row';
COMMENT ON COLUMN spherex.plane.obs_publisher_did IS 'IVOA ID for the dataset, assigned by the publisher (IRSA)';
CREATE INDEX IF NOT EXISTS spherex_plane_obs_publisher_did_idx ON spherex.plane (obs_publisher_did);

-- [SPHEREx: tablas TAP de IRSA] spherex.provenance_input — acceso: TAP IRSA (ADQL)
CREATE TABLE IF NOT EXISTS spherex.provenance_input (
    inputid text,
    outputid text
);
COMMENT ON TABLE spherex.provenance_input IS 'Join tables for SPHEREx calibration files';
COMMENT ON COLUMN spherex.provenance_input.inputid IS 'calibration input plane identifier (plane.planeid)';
COMMENT ON COLUMN spherex.provenance_input.outputid IS 'science output plane identifier (plane.planeid)';

-- [SPHEREx: tablas TAP de IRSA] spherex.splices — acceso: TAP IRSA (ADQL)
CREATE TABLE IF NOT EXISTS spherex.splices (
    source_id bigint,
    designation text,
    ra double precision,
    dec double precision,
    gal_long double precision,
    gal_lat double precision,
    tmassdesignation text,
    tmassra double precision,
    tmassdec double precision,
    j real,
    jerr real,
    h real,
    herr real,
    k real,
    kerr real,
    ph_qual text,
    rd_flg bigint,
    prox double precision,
    w1 real,
    w1err real,
    w2 real,
    w2err real,
    w3 real,
    w3err real,
    w4 real,
    w4err real,
    cc_flags text,
    ext_flg bigint,
    var_flg text,
    irac_designation text,
    ra_irac double precision,
    dec_irac double precision,
    mag3_6 real,
    d3_6m real,
    mag4_5 real,
    d4_5m real,
    mag5_8 real,
    d5_8m real,
    mag8_0 real,
    d8_0m real,
    sel_type text,
    class_1 text,
    yso_pub bigint,
    stype_ml text,
    stype_ml_prob1 double precision,
    stype_ml_prob2 double precision,
    name text,
    gaia_dr3 bigint,
    gaiadr3_g real,
    gaiadr3_gerr double precision,
    gaiadr3_b real,
    gaiadr3_berr double precision,
    gaiadr3_r real,
    gaiadr3_rerr double precision,
    plx double precision,
    e_plx real,
    pmra double precision,
    pmra_err real,
    pmdec double precision,
    pmdec_err real,
    gaiadist real,
    e_dist_upper real,
    e_dist_lower real,
    classvar text,
    w1var bigint,
    w1var_class text,
    w2var bigint,
    w2var_class text,
    w1varavg double precision,
    w2varavg double precision,
    w1varamp double precision,
    w2varamp double precision,
    av double precision,
    mc text,
    mc_lon double precision,
    mc_lat double precision,
    mc_dist double precision,
    mc_avf double precision,
    mc_los text,
    numgaianb bigint,
    maxrmag real,
    sumrflux double precision,
    mainrflux double precision,
    fluxratiogaia double precision,
    mingaiadist real,
    mindistgaiaflux double precision,
    noc bigint,
    noc_gl double precision,
    noc_gb double precision,
    numiracnbors bigint,
    mindistirac real,
    i1mag real,
    maxi1mag real,
    sumi1flux double precision,
    maini1flux double precision,
    mindisti1flux double precision,
    i2mag real,
    maxi2mag real,
    sumi2flux double precision,
    maini2flux double precision,
    mindisti2flux double precision,
    fluxratioi1 double precision,
    fluxratioi2 double precision,
    numvvvneighbors bigint,
    mindistvvv real,
    vvvjmag real,
    maxvvvjmag real,
    sumvvvjflux double precision,
    mainvvvjflux double precision,
    mindistvvvjflux double precision,
    vvvhmag real,
    maxvvvhmag real,
    sumvvvhflux double precision,
    mainvvvhflux double precision,
    mindistvvvhflux double precision,
    vvvkmag real,
    maxvvvkmag real,
    sumvvvkflux double precision,
    mainvvvkflux double precision,
    mindistvvvkflux double precision,
    fluxratiovvvj double precision,
    fluxratiovvvh double precision,
    fluxratiovvvk double precision,
    numuksnbors bigint,
    mindistuks real,
    uksjmag real,
    maxuksjmag real,
    sumuksjflux double precision,
    mainuksjflux double precision,
    mindistuksjflux double precision,
    ukshmag real,
    maxukshmag real,
    sumukshflux double precision,
    mainukshflux double precision,
    mindistukshflux double precision,
    ukskmag real,
    maxukskmag real,
    sumukskflux double precision,
    mainukskflux double precision,
    mindistukskflux double precision,
    fluxratiouksj double precision,
    fluxratiouksh double precision,
    fluxratiouksk double precision,
    varclassgaia text,
    varclassgaiasc double precision,
    sv_w1 text,
    sv_w1_v double precision,
    sv_w1_t double precision,
    sv_w2 text,
    sv_w2_v double precision,
    sv_w2_t double precision,
    x double precision,
    y double precision,
    z double precision,
    spt_ind bigint,
    htm20 bigint,
    cntr bigint
);
COMMENT ON TABLE spherex.splices IS 'The SPHEREx Target List of Ice Sources (SPLICES)';
COMMENT ON COLUMN spherex.splices.source_id IS 'SPLICES source ID';
COMMENT ON COLUMN spherex.splices.designation IS 'Source Designation';
COMMENT ON COLUMN spherex.splices.ra IS 'Right Ascension (J2000) [deg]';
COMMENT ON COLUMN spherex.splices.dec IS 'Declination (J2000) [deg]';
COMMENT ON COLUMN spherex.splices.gal_long IS 'Galactic Longitude [deg]';
COMMENT ON COLUMN spherex.splices.gal_lat IS 'Galactic Latitude [deg]';
COMMENT ON COLUMN spherex.splices.tmassdesignation IS '2MASS source designation';
COMMENT ON COLUMN spherex.splices.tmassra IS '2MASS right ascension [deg]';
COMMENT ON COLUMN spherex.splices.tmassdec IS '2MASS declination [deg]';
COMMENT ON COLUMN spherex.splices.j IS '2MASS J magnitude [mag]';
COMMENT ON COLUMN spherex.splices.jerr IS '2MASS J magnitude uncertainty [mag]';
COMMENT ON COLUMN spherex.splices.h IS '2MASS H magnitude [mag]';
COMMENT ON COLUMN spherex.splices.herr IS '2MASS H magnitude uncertainty [mag]';
COMMENT ON COLUMN spherex.splices.k IS '2MASS K magnitude [mag]';
COMMENT ON COLUMN spherex.splices.kerr IS '2MASS K magnitude uncertainty [mag]';
COMMENT ON COLUMN spherex.splices.ph_qual IS '2MASS photometric quality flag';
COMMENT ON COLUMN spherex.splices.rd_flg IS '2MASS rd_flg';
COMMENT ON COLUMN spherex.splices.prox IS '2MASS prox value [arcsec]';
COMMENT ON COLUMN spherex.splices.w1 IS 'WISE band 1 magnitude [mag]';
COMMENT ON COLUMN spherex.splices.w1err IS 'WISE band 1 magnitude uncertainty [mag]';
COMMENT ON COLUMN spherex.splices.w2 IS 'WISE band 2 magnitude [mag]';
COMMENT ON COLUMN spherex.splices.w2err IS 'WISE band 2 magnitude uncertainty [mag]';
COMMENT ON COLUMN spherex.splices.w3 IS 'WISE band 3 magnitude [mag]';
COMMENT ON COLUMN spherex.splices.w3err IS 'WISE band 3 magnitude uncertainty [mag]';
COMMENT ON COLUMN spherex.splices.w4 IS 'WISE band 4 magnitude [mag]';
COMMENT ON COLUMN spherex.splices.w4err IS 'WISE band 4 magnitude uncertainty [mag]';
COMMENT ON COLUMN spherex.splices.cc_flags IS 'WISE cc_flags';
COMMENT ON COLUMN spherex.splices.ext_flg IS 'WISE ext_flg';
COMMENT ON COLUMN spherex.splices.var_flg IS 'WISE var_flg';
COMMENT ON COLUMN spherex.splices.irac_designation IS 'IRAC source designation';
COMMENT ON COLUMN spherex.splices.ra_irac IS 'IRAC right ascension [deg]';
COMMENT ON COLUMN spherex.splices.dec_irac IS 'IRAC declination [deg]';
COMMENT ON COLUMN spherex.splices.mag3_6 IS 'IRAC 3.6 micron magnitude [mag]';
COMMENT ON COLUMN spherex.splices.d3_6m IS 'IRAC 3.6 micron magnitude uncertainty [mag]';
COMMENT ON COLUMN spherex.splices.mag4_5 IS 'IRAC 4.5 micron magnitude [mag]';
COMMENT ON COLUMN spherex.splices.d4_5m IS 'IRAC 4.5 micron magnitude uncertainty [mag]';
COMMENT ON COLUMN spherex.splices.mag5_8 IS 'IRAC 5.8 micron magnitude [mag]';
COMMENT ON COLUMN spherex.splices.d5_8m IS 'IRAC 5.8 micron magnitude uncertainty [mag]';
COMMENT ON COLUMN spherex.splices.mag8_0 IS 'IRAC 8.0 micron magnitude [mag]';
COMMENT ON COLUMN spherex.splices.d8_0m IS 'IRAC 8.0 micron magnitude uncertainty [mag]';
COMMENT ON COLUMN spherex.splices.sel_type IS 'Source selection method';
COMMENT ON COLUMN spherex.splices.class_1 IS 'Source Class';
COMMENT ON COLUMN spherex.splices.yso_pub IS 'Publication source of YSO classification';
COMMENT ON COLUMN spherex.splices.stype_ml IS 'Machine Learning Source Class';
COMMENT ON COLUMN spherex.splices.stype_ml_prob1 IS 'Machine Learning Source Type Probability Stage 1';
COMMENT ON COLUMN spherex.splices.stype_ml_prob2 IS 'Machine Learning Source Type Probability Stage 2';
COMMENT ON COLUMN spherex.splices.name IS 'Proper Name';
COMMENT ON COLUMN spherex.splices.gaia_dr3 IS 'Gaia DR3 source designation';
COMMENT ON COLUMN spherex.splices.gaiadr3_g IS 'Gaia G band magnitude [mag]';
COMMENT ON COLUMN spherex.splices.gaiadr3_gerr IS 'Gaia G band magnitude uncertainty [mag]';
COMMENT ON COLUMN spherex.splices.gaiadr3_b IS 'Gaia B band magnitude [mag]';
COMMENT ON COLUMN spherex.splices.gaiadr3_berr IS 'Gaia B band magnitude [mag]';
COMMENT ON COLUMN spherex.splices.gaiadr3_r IS 'Gaia R band magnitude [mag]';
COMMENT ON COLUMN spherex.splices.gaiadr3_rerr IS 'Gaia R band magnitude [mag]';
COMMENT ON COLUMN spherex.splices.plx IS 'Gaia parallax [mas]';
COMMENT ON COLUMN spherex.splices.e_plx IS 'Gaia parallax uncertainty [mas]';
COMMENT ON COLUMN spherex.splices.pmra IS 'Right ascension proper motion [mas.yr**-1]';
COMMENT ON COLUMN spherex.splices.pmra_err IS 'Right ascension proper motion uncertainty [mas.yr**-1]';
COMMENT ON COLUMN spherex.splices.pmdec IS 'Declination proper motion [mas.yr**-1]';
COMMENT ON COLUMN spherex.splices.pmdec_err IS 'Declination proper motion uncertainty [mas.yr**-1]';
COMMENT ON COLUMN spherex.splices.gaiadist IS 'Distance derived by Gaia [pc]';
COMMENT ON COLUMN spherex.splices.e_dist_upper IS 'Upper limit of distance 68% confidence range [pc]';
COMMENT ON COLUMN spherex.splices.e_dist_lower IS 'Lower limit of distance 68% confidence range [pc]';
COMMENT ON COLUMN spherex.splices.classvar IS 'Source Class from variability analysis';
COMMENT ON COLUMN spherex.splices.w1var IS 'W1 variability flag';
COMMENT ON COLUMN spherex.splices.w1var_class IS 'W1 variability class';
COMMENT ON COLUMN spherex.splices.w2var IS 'W2 variability flag';
COMMENT ON COLUMN spherex.splices.w2var_class IS 'W2 variability class';
COMMENT ON COLUMN spherex.splices.w1varavg IS 'NEOWISE W1 mean mag [mag]';
COMMENT ON COLUMN spherex.splices.w2varavg IS 'NEOWISE W2 mean mag [mag]';
COMMENT ON COLUMN spherex.splices.w1varamp IS 'NEOWISE W1 variability amplitude [mag]';
COMMENT ON COLUMN spherex.splices.w2varamp IS 'NEOWISE W2 variability amplitude [mag]';
COMMENT ON COLUMN spherex.splices.av IS 'Estimate of Av from H-W2 or K-W2 [mag]';
COMMENT ON COLUMN spherex.splices.mc IS 'Molecular Cloud name';
COMMENT ON COLUMN spherex.splices.mc_lon IS 'Galactic longitude of cloud sightline [deg]';
COMMENT ON COLUMN spherex.splices.mc_lat IS 'Galactic latitude of cloud sightline [deg]';
COMMENT ON COLUMN spherex.splices.mc_dist IS 'Distance of cloud [pc]';
COMMENT ON COLUMN spherex.splices.mc_avf IS 'Foreground Av to cloud [mag]';
COMMENT ON COLUMN spherex.splices.mc_los IS 'Position class';
COMMENT ON COLUMN spherex.splices.numgaianb IS 'Number of Gaia sources &lt;7.6 arcsec from target';
COMMENT ON COLUMN spherex.splices.maxrmag IS 'Maximum Gaia R mag of neighbors [mag]';
COMMENT ON COLUMN spherex.splices.sumrflux IS 'Sum of Gaia R band fluxes of neighbors [uJy]';
COMMENT ON COLUMN spherex.splices.mainrflux IS 'SPLICES target Gaia R flux [uJy]';
COMMENT ON COLUMN spherex.splices.fluxratiogaia IS 'Ratio of bkgnd Gaia flux to SPLICES source flux [%]';
COMMENT ON COLUMN spherex.splices.mingaiadist IS 'Distance to nearest Gaia neighbor [arcsec]';
COMMENT ON COLUMN spherex.splices.mindistgaiaflux IS 'Flux of nearest Gaia neighbor [uJy]';
COMMENT ON COLUMN spherex.splices.noc IS 'Number of clouds along the line of sight (Dame et al.)';
COMMENT ON COLUMN spherex.splices.noc_gl IS 'Galactic longitude of Dame et al. pixel [deg]';
COMMENT ON COLUMN spherex.splices.noc_gb IS 'Galactic latitude of Dame et al. pixel [deg]';
COMMENT ON COLUMN spherex.splices.numiracnbors IS 'Number of IRAC sources &lt;7.6 arcsec from target';
COMMENT ON COLUMN spherex.splices.mindistirac IS 'Distance of closest neighbor [arcsec]';
COMMENT ON COLUMN spherex.splices.i1mag IS 'I1 mag of SPLICES target [mag]';
COMMENT ON COLUMN spherex.splices.maxi1mag IS 'I1 mag of brightest neighbor [mag]';
COMMENT ON COLUMN spherex.splices.sumi1flux IS 'Sum of I1 neighbor fluxes [uJy]';
COMMENT ON COLUMN spherex.splices.maini1flux IS 'I1 Flux of SPLICES target [uJy]';
COMMENT ON COLUMN spherex.splices.mindisti1flux IS 'I1 Flux of closest neighbor [uJy]';
COMMENT ON COLUMN spherex.splices.i2mag IS 'I2 mag of SPLICES target [mag]';
COMMENT ON COLUMN spherex.splices.maxi2mag IS 'I2 mag of brightest neighbor [mag]';
COMMENT ON COLUMN spherex.splices.sumi2flux IS 'Sum of I2 neighbor fluxes [uJy]';
COMMENT ON COLUMN spherex.splices.maini2flux IS 'I2 Flux of SPLICES target [uJy]';
COMMENT ON COLUMN spherex.splices.mindisti2flux IS 'I2 Flux of closest neighbor [uJy]';
COMMENT ON COLUMN spherex.splices.fluxratioi1 IS 'Ratio of bkgnd I1 flux to SPLICES source flux [%]';
COMMENT ON COLUMN spherex.splices.fluxratioi2 IS 'Ratio of bkgnd I2 flux to SPLICES source flux [%]';
COMMENT ON COLUMN spherex.splices.numvvvneighbors IS 'Number of VVV sources &lt;7.6 arcsec from target';
COMMENT ON COLUMN spherex.splices.mindistvvv IS 'Distance to nearest VVV neighbor [arcsec]';
COMMENT ON COLUMN spherex.splices.vvvjmag IS 'VVVJ mag of SPLICES target [mag]';
COMMENT ON COLUMN spherex.splices.maxvvvjmag IS 'VVVJ mag of brightest nearby source [mag]';
COMMENT ON COLUMN spherex.splices.sumvvvjflux IS 'Sum of VVVJ fluxes of background sources [uJy]';
COMMENT ON COLUMN spherex.splices.mainvvvjflux IS 'J band Flux of SPLICES source [uJy]';
COMMENT ON COLUMN spherex.splices.mindistvvvjflux IS 'Flux of nearest VVVJ background source [uJy]';
COMMENT ON COLUMN spherex.splices.vvvhmag IS 'VVVH mag of SPLICES target [mag]';
COMMENT ON COLUMN spherex.splices.maxvvvhmag IS 'VVVH mag of brightest nearby source [mag]';
COMMENT ON COLUMN spherex.splices.sumvvvhflux IS 'Sum of VVVH fluxes of background sources [uJy]';
COMMENT ON COLUMN spherex.splices.mainvvvhflux IS 'H band Flux of SPLICES source [uJy]';
COMMENT ON COLUMN spherex.splices.mindistvvvhflux IS 'Flux of nearest VVVH background source [uJy]';
COMMENT ON COLUMN spherex.splices.vvvkmag IS 'VVVK band mag of SPLICES source [mag]';
COMMENT ON COLUMN spherex.splices.maxvvvkmag IS 'VVVK mag of brightest nearby source [mag]';
COMMENT ON COLUMN spherex.splices.sumvvvkflux IS 'Sum of VVVK fluxes of background sources [uJy]';
COMMENT ON COLUMN spherex.splices.mainvvvkflux IS 'K band Flux of SPLICES source [uJy]';
COMMENT ON COLUMN spherex.splices.mindistvvvkflux IS 'Flux of nearest VVVK background source [uJy]';
COMMENT ON COLUMN spherex.splices.fluxratiovvvj IS 'Ratio of bkgnd VVVJ flux to SPLICES source flux [%]';
COMMENT ON COLUMN spherex.splices.fluxratiovvvh IS 'Ratio of bkgnd VVVH flux to SPLICES source flux [%]';
COMMENT ON COLUMN spherex.splices.fluxratiovvvk IS 'Ratio of bkgnd VVVK flux to SPLICES source flux [%]';
COMMENT ON COLUMN spherex.splices.numuksnbors IS 'Number of UKIDSS sources &lt;7.6 arcsec from target';
COMMENT ON COLUMN spherex.splices.mindistuks IS 'Distance to closest UKIDSS neighbor [arcsec]';
COMMENT ON COLUMN spherex.splices.uksjmag IS 'UKSJ band mag of SPLICES source [mag]';
COMMENT ON COLUMN spherex.splices.maxuksjmag IS 'UKSJ mag of brightest nearby source [mag]';
COMMENT ON COLUMN spherex.splices.sumuksjflux IS 'Sum of UKSJ fluxes of background sources [uJy]';
COMMENT ON COLUMN spherex.splices.mainuksjflux IS 'J band Flux of SPLICES source [uJy]';
COMMENT ON COLUMN spherex.splices.mindistuksjflux IS 'Flux of nearest UKSJ background source [uJy]';
COMMENT ON COLUMN spherex.splices.ukshmag IS 'UKSH band mag of SPLICES source [mag]';
COMMENT ON COLUMN spherex.splices.maxukshmag IS 'UKSH mag of brightest nearby source [mag]';
COMMENT ON COLUMN spherex.splices.sumukshflux IS 'Sum of UKSH fluxes of background sources [uJy]';
COMMENT ON COLUMN spherex.splices.mainukshflux IS 'H band Flux of SPLICES source [uJy]';
COMMENT ON COLUMN spherex.splices.mindistukshflux IS 'Flux of nearest UKSH background source [uJy]';
COMMENT ON COLUMN spherex.splices.ukskmag IS 'UKSK band mag of SPLICES source [mag]';
COMMENT ON COLUMN spherex.splices.maxukskmag IS 'UKSK mag of brightest nearby source [mag]';
COMMENT ON COLUMN spherex.splices.sumukskflux IS 'Sum of UKSK fluxes of background sources [uJy]';
COMMENT ON COLUMN spherex.splices.mainukskflux IS 'K band Flux of SPLICES source [uJy]';
COMMENT ON COLUMN spherex.splices.mindistukskflux IS 'Flux of nearest UKSK background source [uJy]';
COMMENT ON COLUMN spherex.splices.fluxratiouksj IS 'Ratio of bkgnd UKSJ flux to SPLICES source flux [%]';
COMMENT ON COLUMN spherex.splices.fluxratiouksh IS 'Ratio of bkgnd UKSH flux to SPLICES source flux [%]';
COMMENT ON COLUMN spherex.splices.fluxratiouksk IS 'Ratio of bkgnd UKSK flux to SPLICES source flux [%]';
COMMENT ON COLUMN spherex.splices.varclassgaia IS 'Gaia Variability best class';
COMMENT ON COLUMN spherex.splices.varclassgaiasc IS 'Score of the best Gaia class';
COMMENT ON COLUMN spherex.splices.sv_w1 IS 'NEOWISE W1 short-term variability flag';
COMMENT ON COLUMN spherex.splices.sv_w1_v IS 'Number of W1 variable short-term epoch';
COMMENT ON COLUMN spherex.splices.sv_w1_t IS 'Number of W1 total short-term epochs';
COMMENT ON COLUMN spherex.splices.sv_w2 IS 'NEOWISE W2 short-term variability flag';
COMMENT ON COLUMN spherex.splices.sv_w2_v IS 'Number of W2 variable short-term epochs';
COMMENT ON COLUMN spherex.splices.sv_w2_t IS 'Number of W2 total short-term epochs';
COMMENT ON COLUMN spherex.splices.x IS 'unit sphere (x,y,z) position x value';
COMMENT ON COLUMN spherex.splices.y IS 'unit sphere (x,y,z) position y value';
COMMENT ON COLUMN spherex.splices.z IS 'unit sphere (x,y,z) position z value';
COMMENT ON COLUMN spherex.splices.spt_ind IS 'Spatial (x,y,z) index key';
COMMENT ON COLUMN spherex.splices.htm20 IS 'HTM20 spatial index key';
COMMENT ON COLUMN spherex.splices.cntr IS 'entry counter (key) number (unique within table)';
CREATE INDEX IF NOT EXISTS spherex_splices_source_id_idx ON spherex.splices (source_id);

-- [SPHEREx: resultados de API guardados localmente] spherex.imagenes — acceso: SIA2 IRSA (spherex_api.py imagenes)
CREATE TABLE IF NOT EXISTS spherex.imagenes (
    obs_publisher_did text,
    obs_id text,
    obs_collection text,
    energy_bandpassname text,
    dataproduct_type text,
    calib_level smallint,
    s_ra double precision,
    s_dec double precision,
    s_fov double precision,
    s_region text,
    s_pixel_scale double precision,
    em_min double precision,
    em_max double precision,
    em_res_power double precision,
    t_min double precision,
    t_max double precision,
    t_exptime double precision,
    target_name text,
    obs_release_date text,
    access_url text,
    access_estsize bigint,
    cloud_access text
);
COMMENT ON TABLE spherex.imagenes IS 'Imágenes espectrales SPHEREx encontradas con SIA2 (una fila por imagen/detector). No guarda los píxeles, solo metadatos y las URLs para descargarlas o recortarlas.';
COMMENT ON COLUMN spherex.imagenes.obs_publisher_did IS 'Identificador IVOA único de la imagen (ivo://irsa.ipac/<colección>?<obs_id>/D<detector>)';
COMMENT ON COLUMN spherex.imagenes.obs_id IS 'Observation ID: periodo de planeación + contador de giro grande + giro pequeño';
COMMENT ON COLUMN spherex.imagenes.obs_collection IS 'Colección SIA2: spherex_dr1, spherex_dr1_deep, spherex_qr3, spherex_qr3_deep, spherex_dr1_cube';
COMMENT ON COLUMN spherex.imagenes.energy_bandpassname IS 'Detector/banda (SPHEREx-D1 ... SPHEREx-D6)';
COMMENT ON COLUMN spherex.imagenes.dataproduct_type IS 'Tipo de producto (image, cube)';
COMMENT ON COLUMN spherex.imagenes.calib_level IS 'Nivel de calibración ObsCore (2 = imagen calibrada, 3 = cubo)';
COMMENT ON COLUMN spherex.imagenes.s_ra IS 'AR del centro de la imagen (ICRS) [deg]';
COMMENT ON COLUMN spherex.imagenes.s_dec IS 'Dec del centro de la imagen (ICRS) [deg]';
COMMENT ON COLUMN spherex.imagenes.s_fov IS 'Campo de visión [deg]';
COMMENT ON COLUMN spherex.imagenes.s_region IS 'Polígono que cubre la imagen en el cielo (ICRS) [deg]';
COMMENT ON COLUMN spherex.imagenes.s_pixel_scale IS 'Tamaño de píxel [arcsec]';
COMMENT ON COLUMN spherex.imagenes.em_min IS 'Longitud de onda mínima cubierta por la imagen [m]';
COMMENT ON COLUMN spherex.imagenes.em_max IS 'Longitud de onda máxima cubierta por la imagen [m]';
COMMENT ON COLUMN spherex.imagenes.em_res_power IS 'Poder de resolución espectral R';
COMMENT ON COLUMN spherex.imagenes.t_min IS 'Inicio de la exposición (MJD) [d]';
COMMENT ON COLUMN spherex.imagenes.t_max IS 'Fin de la exposición (MJD) [d]';
COMMENT ON COLUMN spherex.imagenes.t_exptime IS 'Tiempo de exposición [s]';
COMMENT ON COLUMN spherex.imagenes.target_name IS 'Campo SPHEREx';
COMMENT ON COLUMN spherex.imagenes.obs_release_date IS 'Fecha de publicación';
COMMENT ON COLUMN spherex.imagenes.access_url IS 'URL HTTPS de la imagen completa en IRSA (acepta ?center=ra,dec&size=grados para recortes)';
COMMENT ON COLUMN spherex.imagenes.access_estsize IS 'Tamaño estimado de la descarga [kbyte]';
COMMENT ON COLUMN spherex.imagenes.cloud_access IS 'JSON con bucket y key de la copia en AWS S3';
CREATE INDEX IF NOT EXISTS spherex_imagenes_obs_publisher_did_idx ON spherex.imagenes (obs_publisher_did);

-- [SPHEREx: resultados de API guardados localmente] spherex.recortes — acceso: IBE Cutouts IRSA (spherex_api.py recorte)
CREATE TABLE IF NOT EXISTS spherex.recortes (
    obs_publisher_did text,
    obs_id text,
    energy_bandpassname text,
    ra double precision,
    dec double precision,
    tamano_deg double precision,
    url_recorte text,
    archivo text,
    bytes bigint
);
COMMENT ON TABLE spherex.recortes IS 'Recortes FITS (MEF con IMAGE, FLAGS, VARIANCE, ZODI, EPSF, WCS-WAVE) descargados localmente.';
COMMENT ON COLUMN spherex.recortes.obs_publisher_did IS 'Imagen de origen (spherex.imagenes.obs_publisher_did)';
COMMENT ON COLUMN spherex.recortes.obs_id IS 'Observation ID';
COMMENT ON COLUMN spherex.recortes.energy_bandpassname IS 'Detector/banda';
COMMENT ON COLUMN spherex.recortes.ra IS 'AR del centro del recorte [deg]';
COMMENT ON COLUMN spherex.recortes.dec IS 'Dec del centro del recorte [deg]';
COMMENT ON COLUMN spherex.recortes.tamano_deg IS 'Lado del recorte [deg]';
COMMENT ON COLUMN spherex.recortes.url_recorte IS 'URL usada para pedir el recorte';
COMMENT ON COLUMN spherex.recortes.archivo IS 'Ruta local del FITS';
COMMENT ON COLUMN spherex.recortes.bytes IS 'Tamaño del archivo [byte]';
CREATE INDEX IF NOT EXISTS spherex_recortes_obs_publisher_did_idx ON spherex.recortes (obs_publisher_did);

-- [Integración Gaia DR3 + SPHEREx] proyecto.espectro_spherex — acceso: Calculado (spherex_api.py espectro)
CREATE TABLE IF NOT EXISTS proyecto.espectro_spherex (
    source_id bigint,
    obs_publisher_did text,
    obs_collection text,
    detector smallint,
    mjd double precision,
    ra_epoca double precision,
    dec_epoca double precision,
    x_pix double precision,
    y_pix double precision,
    longitud_onda_um double precision,
    ancho_banda_um double precision,
    flujo_ujy double precision,
    error_flujo_ujy double precision,
    brillo_pico_mjy_sr double precision,
    fondo_mjy_sr double precision,
    zodi_mjy_sr double precision,
    radio_apertura_pix double precision,
    flags bigint,
    flag_malo boolean
);
COMMENT ON TABLE proyecto.espectro_spherex IS 'Espectro infrarrojo SPHEREx (0.75-5 µm) de fuentes Gaia: una fila por fuente y por imagen donde aparece. Fotometría de apertura sobre los píxeles leídos directamente de S3. Enlaza con gaiadr3.* por source_id.';
COMMENT ON COLUMN proyecto.espectro_spherex.source_id IS 'Identificador Gaia DR3 (NULL si se dio una posición manual)';
COMMENT ON COLUMN proyecto.espectro_spherex.obs_publisher_did IS 'Imagen SPHEREx usada (spherex.imagenes)';
COMMENT ON COLUMN proyecto.espectro_spherex.obs_collection IS 'Colección SPHEREx';
COMMENT ON COLUMN proyecto.espectro_spherex.detector IS 'Detector 1-6 (1-3 SWIR, 4-6 MWIR)';
COMMENT ON COLUMN proyecto.espectro_spherex.mjd IS 'Fecha media de la exposición (MJD-AVG) [d]';
COMMENT ON COLUMN proyecto.espectro_spherex.ra_epoca IS 'AR de la fuente propagada a la fecha de la imagen con el movimiento propio de Gaia [deg]';
COMMENT ON COLUMN proyecto.espectro_spherex.dec_epoca IS 'Dec de la fuente propagada a la fecha de la imagen [deg]';
COMMENT ON COLUMN proyecto.espectro_spherex.x_pix IS 'Posición X en la imagen (0-based) [pix]';
COMMENT ON COLUMN proyecto.espectro_spherex.y_pix IS 'Posición Y en la imagen (0-based) [pix]';
COMMENT ON COLUMN proyecto.espectro_spherex.longitud_onda_um IS 'Longitud de onda central en la posición de la fuente (WCS-WAVE) [um]';
COMMENT ON COLUMN proyecto.espectro_spherex.ancho_banda_um IS 'Ancho de banda en la posición de la fuente [um]';
COMMENT ON COLUMN proyecto.espectro_spherex.flujo_ujy IS 'Flujo en apertura menos fondo local (incluye corrección de zodiacal vía anillo) [uJy]';
COMMENT ON COLUMN proyecto.espectro_spherex.error_flujo_ujy IS 'Error del flujo a partir de la extensión VARIANCE [uJy]';
COMMENT ON COLUMN proyecto.espectro_spherex.brillo_pico_mjy_sr IS 'Brillo superficial del píxel central [MJy/sr]';
COMMENT ON COLUMN proyecto.espectro_spherex.fondo_mjy_sr IS 'Mediana del anillo de fondo [MJy/sr]';
COMMENT ON COLUMN proyecto.espectro_spherex.zodi_mjy_sr IS 'Modelo de luz zodiacal en el píxel central [MJy/sr]';
COMMENT ON COLUMN proyecto.espectro_spherex.radio_apertura_pix IS 'Radio de la apertura [pix]';
COMMENT ON COLUMN proyecto.espectro_spherex.flags IS 'OR de los bits FLAGS dentro de la apertura (definición en la cabecera FLAGS: MSKN/MSKM)';
COMMENT ON COLUMN proyecto.espectro_spherex.flag_malo IS 'True si algún píxel de la apertura tiene un bit grave (transitorio, saturación, no funcional, caliente/frío, no lineal, persistencia, outlier, faltante)';
CREATE INDEX IF NOT EXISTS proyecto_espectro_spherex_source_id_idx ON proyecto.espectro_spherex (source_id);

