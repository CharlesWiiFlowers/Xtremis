# Catálogo de tablas Gaia DR3

Generado por `scripts/02_generar_esquema.py`. **Acceso**: `TAP (ADQL)` = se consulta con SQL/ADQL en el Archivo Gaia; `DataLink (TIPO)` = se pide por `source_id` con `gaia_api.py datalink --tipos TIPO`.


## Catálogo principal (`gaia_source`)

| Tabla | Acceso | Columnas | Filas en DR3 | GB en CDN (gz) | Descripción |
|---|---|---:|---:|---:|---|
| `gaia_source` | TAP (ADQL) | 152 | 1,811,709,771 | 753.026 | This table has an entry for every Gaia observed source as published with this data release. It contains the basic source parameters, in their final state as processed by the Gaia D… |
| `gaia_source_lite` | TAP (ADQL) | 51 | 1,811,709,771 | — | This is a column-wise subset of the gaia_source table named gaia_source_lite. This table has an entry for every Gaia observed source as published with this data release. It contain… |

## Parámetros astrofísicos (`Astrophysical_parameters`)

| Tabla | Acceso | Columnas | Filas en DR3 | GB en CDN (gz) | Descripción |
|---|---|---:|---:|---:|---|
| `astrophysical_parameters` | TAP (ADQL) | 226 | 1,590,932,717 | 255.974 | This is the main table containing the 1D astrophysical parameters produced by the Apsis processing chain developed in Gaia DPAC CU8 (see Chapter~\ref{chap:cu8par}). Additional para… |
| `astrophysical_parameters_supp` | TAP (ADQL) | 175 | 473,020,612 | 200.948 | This table contains additional parameters from the Apsis processing chain, compared to the main table {\tt AstrophysicalParameters} (see Chapter~\ref{chap:cu8par}), from modules th… |
| `mcmc_samples_gsp_phot` | DataLink (MCMC_GSPPHOT) | 16 | — | 3263.258 | This is the DataLink table hosting Monte-Carlo Markov Chain (MCMC) samples for the posterior probability distribution of all parameters derived from the General Stellar Parametrize… |
| `mcmc_samples_msc` | DataLink (MCMC_MSC) | 12 | — | 1393.553 | This is the DataLink table hosting Monte-Carlo Markov Chain (MCMC) samples for the posterior probability distribution of all parameters derived from the Multiple Source Classifier … |
| `oa_neuron_information` | TAP (ADQL) | 78 | 900 | 0.0 | This is the table hosting the content of a Self-Organized Map calculated from a dataset composed by outliers by the Apsis module OA. Each entry corresponds to parameters estimated … |
| `oa_neuron_xp_spectra` | TAP (ADQL) | 7 | 78,300 | 0.001 | This is the table hosting the prototype BP/RP spectrum corresponding to each of the neurons of the Self-Organised-Map produced by the Apsis module OA. Other neuron attributes, such… |
| `total_galactic_extinction_map` | TAP (ADQL) | 10 | 4,177,920 | 0.039 | This table provides the Total Galactic Extinction (TGE) map for extinction parameters $A_0$ describing the effective total Galactic extinction and related uncertainties at four sep… |
| `total_galactic_extinction_map_opt` | TAP (ADQL) | 7 | 3,145,728 | 0.012 | This table provides an optimum version of the Total Galactic Extinction map, derived from the table {{TotalGalacticExtinctionMap}} at a single HEALPix level 9. For this, the mean e… |

## Cruce con catálogos externos (`Cross-match`)

| Tabla | Acceso | Columnas | Filas en DR3 | GB en CDN (gz) | Descripción |
|---|---|---:|---:|---:|---|
| `allwise_best_neighbour` | TAP (ADQL) | 7 | 324,115,003 | — | <p>allWISE BestNeighbour table lists each matched Gaia object with its best neighbour in the external catalogue. The cross-match algorithm is not symmetric and searches Gaia source… |
| `allwise_neighbourhood` | TAP (ADQL) | 6 | 324,116,921 | — | <p>allWISE Neighbourhood table includes all good neighbours for each matched Gaia object. A good neighbour for a given Gaia source is a nearby object in the external catalogue whos… |
| `apassdr9_best_neighbour` | TAP (ADQL) | 7 | 74,904,012 | — | <p>Table <tt>Apassdr9BestNeighbour</tt> lists each matched Gaia object with its best neighbour in the external catalogue. The cross-match algorithm is not symmetric and searches Ga… |
| `apassdr9_join` | TAP (ADQL) | 2 | 61,176,401 | — | Convenience table to be used to join the APASS DR9 catalogue with the cross-match results. The table links the external catalogue original sourceId (originalExtSourceId) to the cor… |
| `apassdr9_neighbourhood` | TAP (ADQL) | 6 | 76,274,759 | — | <p>Table <tt>Apassdr9Neighbourhood</tt> includes all good neighbours for each matched Gaia object. A good neighbour for a given Gaia source is a nearby object in the external catal… |
| `dr2_neighbourhood` | TAP (ADQL) | 5 | 2,113,601,284 | — | Users wishing to look up the E/DR3 record for an astrophysical source identified in DR2 must NOT simply extract the record from E/DR3 having the same source identifier. As describe… |
| `gsc23_best_neighbour` | TAP (ADQL) | 7 | 893,811,527 | — | <p>GSC2.3 BestNeighbour table lists each matched Gaia object with its best neighbour in the external catalogue. The cross-match algorithm is not symmetric and searches Gaia sources… |
| `gsc23_join` | TAP (ADQL) | 2 | 945,592,683 | — | Convenience table to be used to join GSC 2.3 catalogue with the cross-match results. The table links the external catalogue original sourceId (originalExtSourceId) to the correspon… |
| `gsc23_neighbourhood` | TAP (ADQL) | 6 | 896,358,993 | — | <p>GSC2.3 Neighbourhood table includes all good neighbours for each matched Gaia object. A good neighbour for a given Gaia source is a nearby object in the external catalogue whose… |
| `hipparcos2_best_neighbour` | TAP (ADQL) | 5 | 99,525 | — | <p>Hipparcos2 BestNeighbour table lists each matched external catalogue object with its best neighbour in Gaia. The cross-match algorithm is not symmetric and searches Hipparcos2 s… |
| `hipparcos2_neighbourhood` | TAP (ADQL) | 5 | 100,010 | — | <p>Hipparcos2 Neighbourhood table includes all good neighbours for each matched Hipparcos2 object. A good neighbour for a given Hipparcos2 source is a nearby Gaia object whose posi… |
| `panstarrs1_best_neighbour` | TAP (ADQL) | 7 | 951,450,474 | — | <p>Pan-STARRS1 DR1 BestNeighbour table lists each matched Gaia object with its best neighbour in the external catalogue. The cross-match algorithm is not symmetric and searches Gai… |
| `panstarrs1_join` | TAP (ADQL) | 2 | 2,264,263,282 | — | Convenience table to be used to join Pan-STARRS1 DR1.1 catalogue with the cross-match results. The table links the external catalogue original sourceId (originalExtSourceId) to the… |
| `panstarrs1_neighbourhood` | TAP (ADQL) | 6 | 951,850,826 | — | <p>Pan-STARRS1 DR1 Neighbourhood table includes all good neighbours for each matched Gaia object. A good neighbour for a given Gaia source is a nearby object in the external catalo… |
| `ravedr5_best_neighbour` | TAP (ADQL) | 6 | 450,659 | — | <p>RAVE DR5 BestNeighbour table lists each matched external catalogue object with its best neighbour in Gaia. The cross-match algorithm is not symmetric and searches RAVE DR5 sourc… |
| `ravedr5_join` | TAP (ADQL) | 2 | 457,555 | — | Convenience table to be used to join RAVE DR5 catalogue with the cross-match results. The table links the external catalogue original sourceId (originalExtSourceId) to the correspo… |
| `ravedr5_neighbourhood` | TAP (ADQL) | 6 | 456,422 | — | <p>RAVE DR5 Neighbourhood table includes all good neighbours for each matched RAVE DR5 object. A good neighbour for a given RAVE DR5 source is a nearby Gaia object whose position i… |
| `ravedr6_best_neighbour` | TAP (ADQL) | 6 | 450,597 | 0.01 | Table {\tt Ravedr6BestNeighbour} lists each matched external catalogue object with its best neighbour in Gaia. The cross-match algorithm is not symmetric and searches RAVE DR6 sour… |
| `ravedr6_join` | TAP (ADQL) | 2 | 518,387 | 0.003 | Convenience table to be used to join RAVE DR6 catalogue with the cross-match results. The table links the external catalogue original sourceId ({\tt originalExtSourceId}) to the co… |
| `ravedr6_neighbourhood` | TAP (ADQL) | 6 | 456,370 | 0.015 | Table {\tt Ravedr6Neighbourhood} includes all good neighbours for each matched RAVE DR6 object. A good neighbour for a given RAVE DR6 source is a nearby Gaia object whose position … |
| `sdssdr13_best_neighbour` | TAP (ADQL) | 7 | 128,130,925 | — | <p>SDSS DR13 BestNeighbour table lists each matched Gaia object with its best neighbour in the external catalogue. The cross-match algorithm is not symmetric and searches Gaia sour… |
| `sdssdr13_join` | TAP (ADQL) | 2 | 468,180,930 | — | Convenience table to be used to join SDSS DR13 catalogue with the cross-match results. The table links the external catalogue original sourceId (originalExtSourceId) to the corresp… |
| `sdssdr13_neighbourhood` | TAP (ADQL) | 6 | 128,251,974 | — | <p>SDSS DR13 Neighbourhood table includes all good neighbours for each matched Gaia object. A good neighbour for a given Gaia source is a nearby object in the external catalogue wh… |
| `skymapperdr2_best_neighbour` | TAP (ADQL) | 6 | 446,161,579 | — | <p>SkyMapper DR2 BestNeighbour table lists each matched Gaia object with its best neighbour in the external catalogue. The cross-match algorithm is not symmetric and searches Gaia … |
| `skymapperdr2_join` | TAP (ADQL) | 1 | 504,910,161 | — | Convenience table to be used to join SkyMapper DR2 catalogue with the cross-match results. It lists all the SkyMapper DR2 sources which were used in the cross-match. See Documentat… |
| `skymapperdr2_neighbourhood` | TAP (ADQL) | 5 | 446,297,242 | — | <p>SkyMapper DR2 Neighbourhood table includes all good neighbours for each matched Gaia object. A good neighbour for a given Gaia source is a nearby object in the external catalogu… |
| `tmass_psc_xsc_best_neighbour` | TAP (ADQL) | 7 | 469,051,627 | — | <p>2MASS BestNeighbour table lists each matched Gaia object with its best neighbour in the external catalogue. The cross-match algorithm is not symmetric and searches Gaia sources … |
| `tmass_psc_xsc_join` | TAP (ADQL) | 3 | 471,063,502 | — | Convenience table to be used to join 2MASS PSC+XSC catalogue with the cross-match results. The table links the external catalogue original sourceId (originalExtSourceId) to the cor… |
| `tmass_psc_xsc_neighbourhood` | TAP (ADQL) | 6 | 469,600,014 | — | <p>2MASS Neighbourhood table includes all good neighbours for each matched Gaia object. A good neighbour for a given Gaia source is a nearby object in the external catalogue whose … |
| `tycho2tdsc_merge` | TAP (ADQL) | 53 | 2,561,887 | — | Tycho-2 merged with the TDSC catalog and TDSC supplement. The Tycho Double Star Catalogue, (TDSC, ) contains 98482 components of double and multiple systems processed in the Tycho-… |
| `tycho2tdsc_merge_best_neighbour` | TAP (ADQL) | 6 | 2,518,330 | — | <p>Tycho2TDSCmerge BestNeighbour table lists each matched external catalogue object with its best neighbour in Gaia. The cross-match algorithm is not symmetric and searches Tycho2T… |
| `tycho2tdsc_merge_neighbourhood` | TAP (ADQL) | 6 | 2,536,896 | — | <p>Tycho2TDSCmerge Neighbourhood table includes all good neighbours for each matched Tycho2TDSCmerge object. A good neighbour for a given Tycho2TDSCmerge source is a nearby Gaia ob… |
| `urat1_best_neighbour` | TAP (ADQL) | 7 | 227,682,906 | — | <p>URAT-1 BestNeighbour table lists each matched Gaia object with its best neighbour in the external catalogue. The cross-match algorithm is not symmetric and searches Gaia sources… |
| `urat1_neighbourhood` | TAP (ADQL) | 6 | 227,683,310 | — | <p>URAT-1 Neighbourhood table includes all good neighbours for each matched Gaia object. A good neighbour for a given Gaia source is a nearby object in the external catalogue whose… |

## Extragaláctico (`Extra-galactic`)

| Tabla | Acceso | Columnas | Filas en DR3 | GB en CDN (gz) | Descripción |
|---|---|---:|---:|---:|---|
| `galaxy_candidates` | TAP (ADQL) | 38 | 4,842,342 | 0.413 | This table contains parameters derived from various modules dedicated to the classification and characterisation of sources considered as galaxy candidates. This table has been con… |
| `galaxy_catalogue_name` | TAP (ADQL) | 3 | 914,837 | 0.01 | This table provides the list of input catalogues that have been used to select any given source for which morphological analysis parameters are provided in table {\tt GalaxyCandida… |
| `qso_candidates` | TAP (ADQL) | 41 | 6,649,162 | 0.373 | This table contains parameters derived from various modules dedicated to the classification and characterisation of sources considered as QSO candidates. Together with those, the Q… |
| `qso_catalogue_name` | TAP (ADQL) | 3 | 2,722,093 | 0.019 | This table provides the list of input catalogues that have been used to select any given source for which morphological analysis parameters are provided in table \texttt{QsoCandida… |

## Estrellas no simples (binarias) (`Non-single_stars`)

| Tabla | Acceso | Columnas | Filas en DR3 | GB en CDN (gz) | Descripción |
|---|---|---:|---:|---:|---|
| `nss_acceleration_astro` | TAP (ADQL) | 29 | 338,215 | 0.09 | This table contains non-single-star astrometric models for sources having a non-linear proper motion which is compatible with an acceleration solution. Several possible models are … |
| `nss_non_linear_spectro` | TAP (ADQL) | 16 | 56,808 | 0.004 | This table contains non-single-star orbital models for spectroscopic binaries compatible with a trend. Several possible models are hosted within the same table and they are indicat… |
| `nss_two_body_orbit` | TAP (ADQL) | 77 | 443,205 | 0.167 | This table contains non-single-star orbital models for sources compatible with an orbital two-body solution. This covers astrometric binaries, spectroscopic binaries, eclipsing bin… |
| `nss_vim_fl` | TAP (ADQL) | 27 | 870 | 0.0 | This table contains non-single-star models for sources compatible with an Variability Induced Mover (VIM) solution. Several possible models are in principle hosted within the same … |

## Verificación de rendimiento (`Performance_verification`)

| Tabla | Acceso | Columnas | Filas en DR3 | GB en CDN (gz) | Descripción |
|---|---|---:|---:|---:|---|
| `binary_masses` | TAP (ADQL) | 13 | 195,315 | 0.007 | Masses derived from the non-single stars (NSS) solutions with orbital parameters in table {\tt gaiadr3.nss\_two\_body\_orbit}. The table below is described in detail in \cite{DR3-D… |
| `chemical_cartography` | TAP (ADQL) | 45 | 5,591,594 | 1.191 | Orbital parameters, actions, Galactocentric Cartesian coordinates and velocities for the sample of stars used in the DR3 chemical cartographic study of the Milky Way. For further d… |
| `gold_sample_carbon_stars` | TAP (ADQL) | 1 | 15,740 | 0.0 | List of \textit{Gaia} DR3 source IDs for carbon stars extracted from the main list of candidate carbon stars for having C2 and CN molecular bands significantly stronger than usual … |
| `gold_sample_fgkm_stars` | TAP (ADQL) | 21 | 3,273,041 | 0.156 | Stellar astrophysical parameters of the golden sample of F, G, K, and M stars from \cite{DR3-DPACP-123}. Values are identical to the ones in the \texttt{astrophysical\_parameters} … |
| `gold_sample_oba_stars` | TAP (ADQL) | 2 | 3,023,388 | 0.024 | List of \textit{Gaia} DR3 source IDs of O, B, and A-type stars having an effective temperature estimate provided by ESP-HS or/and GSP-Phot greater than 7\,500~K. Based on the infor… |
| `gold_sample_solar_analogues` | TAP (ADQL) | 1 | 5,863 | 0.0 | \textit{Gaia} DR3 source IDs of candidates for solar analogues selected from GSP-Spec via effective temperature, surface gravity and metallicity and from FLAME via mass and radius.… |
| `gold_sample_spss` | TAP (ADQL) | 35 | 111 | 0.0 | Recommended parameters for the Gaia Spectro-Photometric Standard stars \citep{2021MNRAS.503.3660P}, selected as described in \cite{DR3-DPACP-123}, from the available parameters pro… |
| `gold_sample_ucd` | TAP (ADQL) | 7 | 21,062 | 0.001 | The table contains the bolometric luminosities and radii in solar units for a subset of ultracool dwarfs from the Gaia DR3 catalogue, as well as some intermediate quantities used i… |
| `sso_orbits` | TAP (ADQL) | 15 | 154,741 | 0.091 | Orbital parameters and uncertainties computed from the {\tt sso\_observation} astrometric data. The content of the table is described in the DR3 publication \cite{DR3-DPACP-150}. |
| `synthetic_photometry_gspc` | TAP (ADQL) | 54 | 218,936,915 | 41.977 | Gaia Synthetic Photometry Catalogue (GSPC) This is a catalogue of synthetic photometry generated from the Gaia BP/RP mean spectra in Data Release 3 and standardised using wide and … |
| `vari_spurious_signals` | TAP (ADQL) | 38 | 11,754,237 | 1.993 | Several statistics computed for all sources with published photometric time series which can help in the identification of sources that are affected by calibration issues resulting… |

## Fotometría por época (`Photometry`)

| Tabla | Acceso | Columnas | Filas en DR3 | GB en CDN (gz) | Descripción |
|---|---|---:|---:|---:|---|
| `epoch_photometry` | DataLink (EPOCH_PHOTOMETRY) | 48 | — | 72.812 | Epoch photometry. Each row in this table contains the light curve for a given object in bands G, BP and RP as stored in the DataLink Massive data base. This table makes extensive u… |

## Marco de referencia (`Reference_frame`)

| Tabla | Acceso | Columnas | Filas en DR3 | GB en CDN (gz) | Descripción |
|---|---|---:|---:|---:|---|
| `agn_cross_id` | TAP (ADQL) | 3 | 1,614,173 | — | <p>Table <tt>AgnCrossId</tt> lists sources whose positions and proper motions define the celestial reference frame of Gaia catalogue.</p> <p> <tt>AgnCrossId</tt> lists the sources … |
| `frame_rotator_source` | TAP (ADQL) | 5 | 429,249 | — | Sources used to compute the Gaia reference frame. The AGIS frame rotator algorithm has two different parts: the reference frame orientation; and the reference frame spin. The refer… |
| `gaia_crf3_xm` | TAP (ADQL) | 37 | 1,614,173 | 0.063 | This table contains the full cross-match information for the Gaia-CRF3 sources. The Gaia-CRF3 sources were selected from the cross-matches with 17 external QSO catalogues as detail… |

## Alertas científicas (`Science_alerts`)

| Tabla | Acceso | Columnas | Filas en DR3 | GB en CDN (gz) | Descripción |
|---|---|---:|---:|---:|---|
| `alerts_mixedin_sourceids` | TAP (ADQL) | 3 | 94 | 0.0 | Some photometric science alerts mix transits from their primary source and other sources in the catalogue. This is done when those sources are believed to be associated with a sing… |
| `science_alerts` | TAP (ADQL) | 4 | 2,612 | 0.0 | Table containing all Gaia Photometric Science Alerts triggered in the period 25-07-2014 to 28-05-2017, i.e.~the time span covered by DR3. A Gaia Photometric Science Alert is known … |

## Sistema solar (`Solar_system`)

| Tabla | Acceso | Columnas | Filas en DR3 | GB en CDN (gz) | Descripción |
|---|---|---:|---:|---:|---|
| `sso_observation` | TAP (ADQL) | 35 | 23,336,467 | 4.639 | Solar System object observations. Each table line contained data obtained during the transit of the source on a single CCD, during a single transit. The corresponding epoch is prov… |
| `sso_reflectance_spectrum` | TAP (ADQL) | 10 | 968,288 | 0.013 | This table contains the mean BP/RP reflectance spectra of asteroids computed as the ratio between the asteroid flux and an averaged solar analogue flux. In each row, the reflectanc… |
| `sso_source` | TAP (ADQL) | 6 | 158,152 | 0.002 | This table contains data related to Solar System objects observed by Gaia. The quantities in the table are derived from data reduction and are associated to single objects. |

## Espectroscopía (`Spectroscopy`)

| Tabla | Acceso | Columnas | Filas en DR3 | GB en CDN (gz) | Descripción |
|---|---|---:|---:|---:|---|
| `rvs_mean_spectrum` | DataLink (RVS) | 9 | — | 20.423 | This is the RVS mean sampled spectrum table. The spectra are in the rest frame, they are normalised and their wavelength grid ranges from 846 to 870 nm in steps of 0.01 nm (2401 el… |
| `xp_continuous_mean_spectrum` | DataLink (XP_CONTINUOUS) | 26 | — | 3609.79 | Table hosting the mean BP and RP spectra based on the continuous representation in basis functions (see~\secref{cu5pho_ssec:meanSpecGen}). Note this table is not available through … |
| `xp_sampled_mean_spectrum` | DataLink (XP_SAMPLED) | 6 | — | 114.427 | This is the BP/RP externally calibrated sampled mean spectrum. All mean spectra are sampled to the same set of absolute wavelength positions, viz.~343 values from 336~to 1020~nm wi… |
| `xp_summary` | TAP (ADQL) | 20 | 219,197,643 | 9.698 | This tables contains auxiliary information about the mean BP/RP spectrum of a given source. It should be used in order to refine queries on spectra and build dedicated samples befo… |

## Variabilidad (`Variability`)

| Tabla | Acceso | Columnas | Filas en DR3 | GB en CDN (gz) | Descripción |
|---|---|---:|---:|---:|---|
| `vari_agn` | TAP (ADQL) | 7 | 872,228 | 0.031 | This table provides information on AGN properties. |
| `vari_cepheid` | TAP (ADQL) | 81 | 15,021 | 0.012 | This table describes the Cepheid stars. |
| `vari_classifier_class_definition` | TAP (ADQL) | 4 | 24 | 0.0 | Table with detailed descriptions of published classes for each classifier described in {\tt VariClassifierDefinition} and used in table {\tt VariClassifierResult}. In DR3, this tab… |
| `vari_classifier_definition` | TAP (ADQL) | 3 | 1 | 0.0 | Table with detailed descriptions of all classifiers used in table {\tt VariClassifierResult}. Details of the published classes for each classifier can be found in {\tt VariClassifi… |
| `vari_classifier_result` | TAP (ADQL) | 5 | 9,976,881 | 0.151 | Table with variability classification results of all classifiers, which are identified by the {\tt classifierName} column. In DR3, multiple classifiers (depending on class) are com… |
| `vari_compact_companion` | TAP (ADQL) | 26 | 6,306 | 0.004 | This table describes the compact companion candidates. |
| `vari_eclipsing_binary` | TAP (ADQL) | 39 | 2,184,477 | 0.345 | This table describes the properties of the eclipsing binaries resulting from the variability analysis. |
| `vari_epoch_radial_velocity` | TAP (ADQL) | 7 | 43,298 | 0.003 | This table contains the epoch radial velocity data points for a sub-set of variable stars. Each entry is a radial velocity in the solar barycentric reference frame for a given obje… |
| `vari_long_period_variable` | TAP (ADQL) | 7 | 1,720,588 | 0.032 | This table describes the Long Period Variable stars. Some entries can be NaN when absent. |
| `vari_microlensing` | TAP (ADQL) | 36 | 363 | 0.0 | This table describes the microlensing events. |
| `vari_ms_oscillator` | TAP (ADQL) | 11 | 54,476 | 0.004 | This table describes the main-sequence oscillators. |
| `vari_planetary_transit` | TAP (ADQL) | 7 | 214 | 0.0 | This table describes the Planetary Transit candidate events. |
| `vari_planetary_transit_13june2022` | TAP (ADQL) | 7 | 214 | 0.0 | This table describes the Planetary Transit candidate events. |
| `vari_rad_vel_statistics` | TAP (ADQL) | 16 | 1,898 | 0.001 | Statistical parameters of radial velocity time series, using only transits not rejected, see {\tt rejectedByVariability} column in {\tt VariEpochRadialVelocity}. Note that NaN will… |
| `vari_rotation_modulation` | TAP (ADQL) | 66 | 474,026 | 0.569 | This table describes the solar-like stars with rotational modulation. |
| `vari_rrlyrae` | TAP (ADQL) | 78 | 271,779 | 0.111 | This table describes the RR Lyrae stars. |
| `vari_short_timescale` | TAP (ADQL) | 9 | 471,679 | 0.023 | This table describes the short-timescale sources. |
| `vari_summary` | TAP (ADQL) | 68 | 11,754,237 | 3.095 | Summary table that provides the information on where a {\tt sourceId} can be found in the different {\tt Variability} tables and statistical parameters of time series, using only t… |

## Simulación (`Simulation`)

| Tabla | Acceso | Columnas | Filas en DR3 | GB en CDN (gz) | Descripción |
|---|---|---:|---:|---:|---|
| `gaia_source_simulation` | TAP (ADQL) | 38 | 1,644,237,695 | — | Table of sources realised according to the Gaia Object Generator (GOG) simulation. Observed attributes are given with simulated observational uncertainties. This table contains the… |
| `gaia_universe_model` | TAP (ADQL) | 43 | 4,378,670,080 | — | Table of simulated galactic stars according to the Gaia Universal Model Simulation (GUMS). True values of the intrinsic simulated quantities (astrometry, photometry and physical pa… |

## Auxiliar (`Auxiliary`)

| Tabla | Acceso | Columnas | Filas en DR3 | GB en CDN (gz) | Descripción |
|---|---|---:|---:|---:|---|
| `commanded_scan_law` | TAP (ADQL) | 13 | 8,967,691 | — | This table provides a representation of the Gaia scanning law over the 34 month time period covered by the Gaia Data Release 3 (from 2014-07-25 10:31:26 to 2017-05-28 08:46:29), in… |
