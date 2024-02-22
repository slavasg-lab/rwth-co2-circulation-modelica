within ;
package Package_CO2_Kreislauf "Package für das Modell des CO2-Kreislaufs"
  import Modelica.SIunits.*;
  import Modelica.Math.*;
/////////////
// Konstanten
/////////////
  constant MolarMass M_C =     12.01E-3;      // Molare Masse Kohlenstoff,  kg/ mol
  constant MolarMass M_Luft =   28.97E-3;      // Molare Masse Luft in der Atmosphäre,  kg/ mol
  constant Mass m_ges_atm =        5.135E18;      // Gesamtmasse Luft in der Atmosphäre, kg
  constant Volume V_ozean =    1.5E18;        // Volumen des Ozeans, m^3
  constant Volume V_flach =    3.5705e16;     // Volumen der flachen Ozeanschicht, m^3
//////////
// Systeme
//////////
  model Biosphaere "Teilsystem Biosphäre"
    // (Für dieses Teilmodell können Sie die Gleichungen aus den Folien verwenden)
  // Parameter
    parameter Mass m_C_start = 2300E12
      "Anfangswert für Kohlenstoff-Menge in der Biosphäre";  // kg C
    parameter MoleFraction x_CO2_GG = 270E-6
      "CO2-Konzentration der Luft in der Biosphäre"; // konstante Bezugsgröße für CO2-Aufnahme in der Biosphäre,  mol/mol
  // Variablen
    Mass m_C(start=m_C_start) "Kohlenstoff-Menge in der Biosphäre";   // kg C
    MoleFraction x;
    MolarFlowRate J_c_atmbio;

    // Konnektor
    KonnektorLuft konAtmVS annotation (Placement(transformation(extent={{-6,-8},
              {14,12}}), iconTransformation(extent={{-6,-8},{14,12}})));
  equation
    // Gleichungen (bitte ergänzen)
    der(m_C)=M_C*J_c_atmbio;
    x = x_CO2_GG;

    konAtmVS.J = J_c_atmbio;
    konAtmVS.x =x;
  end Biosphaere;

  model Atmosphaere "Teilsystem Atmosphäre"
  // Bitte ergänzen
  //hier Parameter definieren
    parameter Mass m_C_start=590*10^12;
  // Variablen (wenn nötig bitte ergänzen)
    Mass m_C(start=m_C_start) "Kohlenstoff-Menge in der Atmosphäre";   // kg C
    MolarFlowRate J_c_bioatm;
    MolarFlowRate J_c_flachatm;
    MolarFlowRate Emission;
    MoleFraction x_CO2_atm;//Stoffmengeanteil CO2 in der Atmosphäre
    MoleFraction x_CO2_gemessen;//CO2 Daten aud der Tabelle in ppm
    MoleFraction x_CO2_berechnet;//Stoffmengeanteil CO2 in der Atmosphäre in ppm
    MoleFraction x_CO2_delta;//Unterschied x_CO2_gemessen und x_CO2_berechnet
    MoleFraction x_CO2_max;//Maximaler Unterschied x_CO2_gemessen und x_CO2_berechnet
    // Konnektor(en)
  //Die Tabellierten Daten benötigen Sie erst in Labor 6 und 7.
  // CO2-Messdaten in ppm aus folgenden Quellen:
  // Tabelle_fossil und Tabelle_landwirtschaft in kg_C/Jahr
  // Daten vom CDIAC  http://cdiac.ornl.gov/trends/co2/lawdome.html
  // Historical CO2 Records from the Law Dome DE08, DE08-2, and DSS Ice Cores
  // und Luftmessungen, Mauna Loa, Hawaii:  http://www.esrl.noaa.gov/gmd/ccgg/trends/co2_data_mlo.html
  protected
     constant Real x_CO2_Messdaten[ :, :] = [ 1006,  279.4;  1046,  280.3;  1096,  282.4;  1146,  283.8;  1196,  283.9;  1246,  281.7;  1327,  283.4;  1387,  280;  1387,  280.4;  1446,  281.7;  1465,  279.6;  1499,  282.4;  1527,  283.2;  1547,  282.8;  1570,  281.9;  1589,  278.7;  1604,  274.3;  1647,  277.2;  1679,  275.9;  1692,  276.5;  1720,  277.5;  1747,  276.9;  1749,  277.2;  1760,  276.7;  1777,  279.5;  1794,  281.6;  1796,  283.7;  1825,  285.1;  1832,  284.5;  1840,  283;  1845,  286.1;  1850,  285.2;  1854,  284.9;  1861,  286.6;  1869,  287.4;  1877,  288.8;  1882,  291.9;  1886,  293.7;  1891,  294.7;  1892,  294.6;  1898,  294.7;  1899,  296.5;  1905,  296.9;  1905,  298.5;  1905,  299;  1912,  300.7;  1915,  301.3;  1924,  304.8;  1924,  304.1;  1926,  305;  1929,  305.2;  1932,  307.8;  1934,  309.2;  1936,  307.9;  1938,  310.5;  1939,  311;  1939,  309.2;  1940,  310.5;  1944,  309.7;  1948,  309.9;  1948,  311.4;  1953,  311.9;  1953,  311;  1953,  312.7;  1954,  313.6;  1954,  314.7;  1954,  314.1;  1959,  315.7;  1962,  318.7;  1962,  317;  1962,  319.4;  1962,  317;  1963,  318.2;  1965,  319.5;  1965,  318.8;  1968,  323.7;  1969,  323.2;  1970,  325.2;  1970,  324.7;  1971,  324.1;  1973,  328.1;  1975,  331.2;  1978,  335.2;  1978,  332;  1980.042,  338.33;  1980.125,  339.04;  1980.208,  339.36;  1980.292,  339.73;  1980.375,  340.16;  1980.458,  339.73;  1980.542,  338.2;  1980.625,  336.99;  1980.708,  336.81;  1980.792,  337.57;  1980.875,  338.69;  1980.958,  339.41;  1981.042,  339.96;  1981.125,  340.51;  1981.208,  341.14;  1981.292,  341.42;  1981.375,  341.13;  1981.458,  340.33;  1981.542,  338.97;  1981.625,  337.84;  1981.708,  337.71;  1981.792,  338.78;  1981.875,  339.87;  1981.958,  340.45;  1982.042,  341.09;  1982.125,  341.67;  1982.208,  341.94;  1982.292,  342.22;  1982.375,  342.06;  1982.458,  341.18;  1982.542,  339.45;  1982.625,  337.81;  1982.708,  337.86;  1982.792,  339.32;  1982.875,  340.63;  1982.958,  341.46;  1983.042,  342.07;  1983.125,  342.43;  1983.208,  342.72;  1983.292,  343.2;  1983.375,  343.5;  1983.458,  343.19;  1983.542,  341.83;  1983.625,  340.32;  1983.708,  340.25;  1983.792,  341.44;  1983.875,  342.46;  1983.958,  343.15;  1984.042,  344.04;  1984.125,  344.56;  1984.208,  344.68;  1984.292,  344.93;  1984.375,  345.08;  1984.458,  344.3;  1984.542,  342.94;  1984.625,  341.97;  1984.708,  341.87;  1984.792,  342.74;  1984.875,  343.91;  1984.958,  344.76;  1985.042,  345.1;  1985.125,  345.55;  1985.208,  346.4;  1985.292,  346.69;  1985.375,  346.51;  1985.458,  346.01;  1985.542,  344.71;  1985.625,  343.22;  1985.708,  343.16;  1985.792,  344.42;  1985.875,  345.55;  1985.958,  346.3;  1986.042,  346.86;  1986.125,  347.08;  1986.208,  347.46;  1986.292,  347.98;  1986.375,  348.08;  1986.458,  347.52;  1986.542,  346.06;  1986.625,  344.69;  1986.708,  344.59;  1986.792,  345.77;  1986.875,  347.08;  1986.958,  347.51;  1987.042,  347.74;  1987.125,  348.3;  1987.208,  349.03;  1987.292,  349.73;  1987.375,  350;  1987.458,  349.23;  1987.542,  347.69;  1987.625,  346.43;  1987.708,  346.47;  1987.792,  347.73;  1987.875,  349;  1987.958,  349.96;  1988.042,  350.68;  1988.125,  351.25;  1988.208,  351.64;  1988.292,  352.1;  1988.375,  352.24;  1988.458,  351.55;  1988.542,  350.1;  1988.625,  348.92;  1988.708,  349.08;  1988.792,  350.23;  1988.875,  351.42;  1988.958,  352.29;  1989.042,  352.84;  1989.125,  353.29;  1989.208,  353.83;  1989.292,  354.2;  1989.375,  354.05;  1989.458,  353.11;  1989.542,  351.37;  1989.625,  350.02;  1989.708,  350.35;  1989.792,  351.61;  1989.875,  352.79;  1989.958,  353.66;  1990.042,  354.22;  1990.125,  354.62;  1990.208,  354.94;  1990.292,  355.28;  1990.375,  355.19;  1990.458,  354.1;  1990.542,  352.5;  1990.625,  351.38;  1990.708,  351.57;  1990.792,  352.98;  1990.875,  354.22;  1990.958,  354.96;  1991.042,  355.51;  1991.125,  355.91;  1991.208,  356.47;  1991.292,  357;  1991.375,  356.89;  1991.458,  356.01;  1991.542,  354.33;  1991.625,  352.83;  1991.708,  352.74;  1991.792,  353.78;  1991.875,  354.92;  1991.958,  355.77;  1992.042,  356.39;  1992.125,  356.72;  1992.208,  357.06;  1992.292,  357.54;  1992.375,  357.6;  1992.458,  356.69;  1992.542,  354.99;  1992.625,  353.39;  1992.708,  353.31;  1992.792,  354.57;  1992.875,  355.75;  1992.958,  356.51;  1993.042,  356.98;  1993.125,  357.32;  1993.208,  357.73;  1993.292,  358.2;  1993.375,  358.15;  1993.458,  357.14;  1993.542,  355.5;  1993.625,  354.18;  1993.708,  354.22;  1993.792,  355.46;  1993.875,  356.69;  1993.958,  357.59;  1994.042,  358.19;  1994.125,  358.72;  1994.208,  359.06;  1994.292,  359.41;  1994.375,  359.43;  1994.458,  358.48;  1994.542,  356.99;  1994.625,  355.78;  1994.708,  355.72;  1994.792,  356.94;  1994.875,  358.4;  1994.958,  359.27;  1995.042,  359.83;  1995.125,  360.3;  1995.208,  360.78;  1995.292,  361.24;  1995.375,  361.14;  1995.458,  360.3;  1995.542,  358.67;  1995.625,  357.39;  1995.708,  357.72;  1995.792,  359.1;  1995.875,  360.44;  1995.958,  361.32;  1996.042,  361.81;  1996.125,  362.14;  1996.208,  362.46;  1996.292,  362.8;  1996.375,  362.94;  1996.458,  362.55;  1996.542,  361.28;  1996.625,  359.78;  1996.708,  359.4;  1996.792,  360.39;  1996.875,  361.52;  1996.958,  362.36;  1997.042,  362.98;  1997.125,  363.32;  1997.208,  363.69;  1997.292,  364.19;  1997.375,  364.24;  1997.458,  363.34;  1997.542,  361.67;  1997.625,  360.14;  1997.708,  360.14;  1997.792,  361.66;  1997.875,  363.34;  1997.958,  364.4;  1998.042,  364.91;  1998.125,  365.22;  1998.208,  365.7;  1998.292,  366.32;  1998.375,  366.58;  1998.458,  366.02;  1998.542,  364.59;  1998.625,  363.57;  1998.708,  363.87;  1998.792,  365.21;  1998.875,  366.45;  1998.958,  367.27;  1999.042,  367.89;  1999.125,  368.26;  1999.208,  368.64;  1999.292,  369.04;  1999.375,  368.98;  1999.458,  368.11;  1999.542,  366.39;  1999.625,  365.06;  1999.708,  365.26;  1999.792,  366.58;  1999.875,  367.86;  1999.958,  368.69;  2000.042,  369.2;  2000.125,  369.48;  2000.208,  369.8;  2000.292,  370.15;  2000.375,  370.05;  2000.458,  369.11;  2000.542,  367.69;  2000.625,  366.52;  2000.708,  366.49;  2000.792,  367.73;  2000.875,  369.11;  2000.958,  369.93;  2001.042,  370.45;  2001.125,  370.9;  2001.208,  371.29;  2001.292,  371.64;  2001.375,  371.57;  2001.458,  370.67;  2001.542,  369.27;  2001.625,  368.12;  2001.708,  368.16;  2001.792,  369.51;  2001.875,  370.86;  2001.958,  371.79;  2002.042,  372.31;  2002.125,  372.69;  2002.208,  373.2;  2002.292,  373.54;  2002.375,  373.52;  2002.458,  372.66;  2002.542,  371.23;  2002.625,  370.16;  2002.708,  370.48;  2002.792,  371.75;  2002.875,  373.1;  2002.958,  374.09;  2003.042,  374.75;  2003.125,  375.28;  2003.208,  375.72;  2003.292,  376.19;  2003.375,  376.33;  2003.458,  375.48;  2003.542,  373.94;  2003.625,  372.7;  2003.708,  372.9;  2003.792,  374.2;  2003.875,  375.48;  2003.958,  376.32;  2004.042,  376.98;  2004.125,  377.5;  2004.208,  377.92;  2004.292,  378.28;  2004.375,  378.21;  2004.458,  377.34;  2004.542,  375.8;  2004.625,  374.34;  2004.708,  374.24;  2004.792,  375.55;  2004.875,  377.01;  2004.958,  377.99;  2005.042,  378.58;  2005.125,  378.99;  2005.208,  379.6;  2005.292,  380.12;  2005.375,  380.25;  2005.458,  379.42;  2005.542,  377.72;  2005.625,  376.48;  2005.708,  376.55;  2005.792,  377.87;  2005.875,  379.35;  2005.958,  380.34;  2006.042,  381.1;  2006.125,  381.72;  2006.208,  382.11;  2006.292,  382.43;  2006.375,  382.38;  2006.458,  381.53;  2006.542,  379.86;  2006.625,  378.3;  2006.708,  378.43;  2006.792,  379.84;  2006.875,  381.19;  2006.958,  382.15;  2007.042,  382.82;  2007.125,  383.35;  2007.208,  383.81;  2007.292,  384.1;  2007.375,  383.96;  2007.458,  383.08;  2007.542,  381.39;  2007.625,  380.12;  2007.708,  380.5;  2007.792,  381.89;  2007.875,  383.23;  2007.958,  384.26;  2008.042,  385.04;  2008.125,  385.62;  2008.208,  385.96;  2008.292,  386.24;  2008.375,  386.29;  2008.458,  385.38;  2008.542,  383.8;  2008.625,  382.47;  2008.708,  382.4];
     constant Real Tabelle_fossil[:, :] = [ 1751,  3000000000;  1752,  3000000000;  1753,  3000000000;  1754,  3000000000;  1755,  3000000000;  1756,  3000000000;  1757,  3000000000;  1758,  3000000000;  1759,  3000000000;  1760,  3000000000;  1761,  3000000000;  1762,  3000000000;  1763,  3000000000;  1764,  3000000000;  1765,  3000000000;  1766,  3000000000;  1767,  3000000000;  1768,  3000000000;  1769,  3000000000;  1770,  3000000000;  1771,  4000000000;  1772,  4000000000;  1773,  4000000000;  1774,  4000000000;  1775,  4000000000;  1776,  4000000000;  1777,  4000000000;  1778,  4000000000;  1779,  4000000000;  1780,  4000000000;  1781,  5000000000;  1782,  5000000000;  1783,  5000000000;  1784,  5000000000;  1785,  5000000000;  1786,  5000000000;  1787,  5000000000;  1788,  5000000000;  1789,  5000000000;  1790,  5000000000;  1791,  6000000000;  1792,  6000000000;  1793,  6000000000;  1794,  6000000000;  1795,  6000000000;  1796,  6000000000;  1797,  7000000000;  1798,  7000000000;  1799,  7000000000;  1800,  8000000000;  1801,  8000000000;  1802,  10000000000;  1803,  9000000000;  1804,  9000000000;  1805,  9000000000;  1806,  10000000000;  1807,  10000000000;  1808,  10000000000;  1809,  10000000000;  1810,  10000000000;  1811,  11000000000;  1812,  11000000000;  1813,  11000000000;  1814,  11000000000;  1815,  12000000000;  1816,  13000000000;  1817,  14000000000;  1818,  14000000000;  1819,  14000000000;  1820,  14000000000;  1821,  14000000000;  1822,  15000000000;  1823,  16000000000;  1824,  16000000000;  1825,  17000000000;  1826,  17000000000;  1827,  18000000000;  1828,  18000000000;  1829,  18000000000;  1830,  24000000000;  1831,  23000000000;  1832,  23000000000;  1833,  24000000000;  1834,  24000000000;  1835,  25000000000;  1836,  29000000000;  1837,  29000000000;  1838,  30000000000;  1839,  31000000000;  1840,  33000000000;  1841,  34000000000;  1842,  36000000000;  1843,  37000000000;  1844,  39000000000;  1845,  43000000000;  1846,  43000000000;  1847,  46000000000;  1848,  47000000000;  1849,  50000000000;  1850,  54000000000;  1851,  54000000000;  1852,  57000000000;  1853,  59000000000;  1854,  69000000000;  1855,  71000000000;  1856,  76000000000;  1857,  77000000000;  1858,  78000000000;  1859,  83000000000;  1860,  91000000000;  1861,  95000000000;  1862,  97000000000;  1863,  104000000000;  1864,  112000000000;  1865,  119000000000;  1866,  122000000000;  1867,  130000000000;  1868,  135000000000;  1869,  142000000000;  1870,  147000000000;  1871,  156000000000;  1872,  173000000000;  1873,  184000000000;  1874,  174000000000;  1875,  188000000000;  1876,  191000000000;  1877,  194000000000;  1878,  196000000000;  1879,  210000000000;  1880,  236000000000;  1881,  243000000000;  1882,  256000000000;  1883,  272000000000;  1884,  275000000000;  1885,  277000000000;  1886,  281000000000;  1887,  295000000000;  1888,  327000000000;  1889,  327000000000;  1890,  356000000000;  1891,  372000000000;  1892,  374000000000;  1893,  370000000000;  1894,  383000000000;  1895,  406000000000;  1896,  419000000000;  1897,  440000000000;  1898,  465000000000;  1899,  507000000000;  1900,  534000000000;  1901,  552000000000;  1902,  566000000000;  1903,  617000000000;  1904,  624000000000;  1905,  663000000000;  1906,  707000000000;  1907,  784000000000;  1908,  750000000000;  1909,  785000000000;  1910,  819000000000;  1911,  836000000000;  1912,  879000000000;  1913,  943000000000;  1914,  850000000000;  1915,  838000000000;  1916,  901000000000;  1917,  955000000000;  1918,  936000000000;  1919,  806000000000;  1920,  932000000000;  1921,  803000000000;  1922,  845000000000;  1923,  970000000000;  1924,  963000000000;  1925,  975000000000;  1926,  983000000000;  1927,  1062000000000;  1928,  1065000000000;  1929,  1145000000000;  1930,  1053000000000;  1931,  940000000000;  1932,  847000000000;  1933,  893000000000;  1934,  973000000000;  1935,  1027000000000;  1936,  1130000000000;  1937,  1209000000000;  1938,  1142000000000;  1939,  1192000000000;  1940,  1299000000000;  1941,  1334000000000;  1942,  1342000000000;  1943,  1391000000000;  1944,  1383000000000;  1945,  1160000000000;  1946,  1238000000000;  1947,  1392000000000;  1948,  1469000000000;  1949,  1419000000000;  1950,  1630000000000;  1951,  1768000000000;  1952,  1796000000000;  1953,  1841000000000;  1954,  1865000000000;  1955,  2043000000000;  1956,  2178000000000;  1957,  2270000000000;  1958,  2330000000000;  1959,  2462000000000;  1960,  2577000000000;  1961,  2594000000000;  1962,  2700000000000;  1963,  2848000000000;  1964,  3008000000000;  1965,  3145000000000;  1966,  3305000000000;  1967,  3411000000000;  1968,  3588000000000;  1969,  3800000000000;  1970,  4076000000000;  1971,  4231000000000;  1972,  4399000000000;  1973,  4635000000000;  1974,  4644000000000;  1975,  4615000000000;  1976,  4883000000000;  1977,  5029000000000;  1978,  5105000000000;  1979,  5387000000000;  1980,  5332000000000;  1981,  5168000000000;  1982,  5127000000000;  1983,  5110000000000;  1984,  5290000000000;  1985,  5444000000000;  1986,  5610000000000;  1987,  5753000000000;  1988,  5964000000000;  1989,  6089000000000;  1990,  6164000000000;  1991,  6252000000000;  1992,  6147000000000;  1993,  6155000000000;  1994,  6273000000000;  1995,  6400000000000;  1996,  6525000000000;  1997,  6633000000000;  1998,  6591000000000;  1999,  6573000000000;  2000,  6745000000000;  2001,  6924000000000;  2002,  6971000000000;  2003,  7306000000000;  2004,  7692000000000;  2005,  7985000000000]; //  global emission data:  http://cdiac.ornl.gov/trends/emis/tre_glob.html
     constant Real Tabelle_landwirtschaft[ :, :] = [ 1751, 492700000000;    1850,  500600000000;  1851,  492700000000;  1852,  548500000000;  1853,  546799999999.9999;  1854,  544799999999.9999;  1855,  542100000000;  1856,  547700000000.0001;  1857,  553300000000;  1858,  558600000000;  1859,  564000000000;  1860,  569000000000;  1861,  579600000000;  1862,  520900000000;  1863,  521100000000;  1864,  521600000000;  1865,  522400000000;  1866,  522500000000;  1867,  520799999999.9999;  1868,  519200000000.0001;  1869,  517500000000;  1870,  516299999999.9999;  1871,  536700000000.0001;  1872,  623200000000;  1873,  634100000000;  1874,  641100000000;  1875,  648400000000;  1876,  655500000000;  1877,  662400000000;  1878,  669500000000;  1879,  676400000000;  1880,  682900000000;  1881,  718900000000;  1882,  672700000000;  1883,  678300000000;  1884,  683400000000;  1885,  687700000000;  1886,  690400000000;  1887,  689800000000;  1888,  688600000000;  1889,  687200000000;  1890,  685900000000;  1891,  681500000000;  1892,  695000000000;  1893,  695800000000;  1894,  713300000000;  1895,  717500000000;  1896,  719400000000;  1897,  723000000000;  1898,  724500000000;  1899,  725800000000;  1900,  726900000000;  1901,  792800000000;  1902,  796800000000;  1903,  825900000000;  1904,  852400000000;  1905,  878500000000;  1906,  909500000000;  1907,  918600000000;  1908,  927900000000;  1909,  935300000000;  1910,  941000000000;  1911,  882900000000;  1912,  846200000000;  1913,  815900000000;  1914,  804800000000;  1915,  793000000000;  1916,  795100000000;  1917,  798200000000;  1918,  801400000000;  1919,  807100000000;  1920,  808800000000;  1921,  856700000000;  1922,  849100000000;  1923,  857000000000;  1924,  862700000000;  1925,  865600000000;  1926,  870500000000;  1927,  909700000000;  1928,  913000000000;  1929,  940000000000;  1930,  1018100000000;  1931,  1028700000000;  1932,  930800000000;  1933,  927600000000;  1934,  915300000000;  1935,  913700000000;  1936,  922000000000;  1937,  899300000000;  1938,  902400000000;  1939,  900500000000;  1940,  887500000000;  1941,  870200000000;  1942,  891300000000;  1943,  886400000000;  1944,  892300000000;  1945,  894100000000;  1946,  976900000000;  1947,  1008900000000;  1948,  1015800000000;  1949,  1024900000000;  1950,  1037300000000;  1951,  1258300000000;  1952,  1284700000000;  1953,  1280900000000;  1954,  1335000000000;  1955,  1379500000000;  1956,  1438900000000;  1957,  1469100000000;  1958,  1520800000000;  1959,  1397800000000;  1960,  1385800000000;  1961,  1463900000000;  1962,  1460000000000;  1963,  1474900000000;  1964,  1487100000000;  1965,  1505000000000;  1966,  1539300000000;  1967,  1545800000000;  1968,  1477700000000;  1969,  1483100000000;  1970,  1439700000000;  1971,  1291700000000;  1972,  1264200000000;  1973,  1248700000000;  1974,  1254500000000;  1975,  1245100000000;  1976,  1311900000000;  1977,  1315100000000;  1978,  1311900000000;  1979,  1283800000000;  1980,  1239900000000;  1981,  1263400000000;  1982,  1463000000000;  1983,  1512900000000;  1984,  1560100000000;  1985,  1583200000000;  1986,  1601100000000;  1987,  1611100000000;  1988,  1638500000000;  1989,  1647000000000;  1990,  1643700000000;  1991,  1712500000000;  1992,  1605000000000;  1993,  1593800000000;  1994,  1580500000000;  1995,  1561600000000;  1996,  1531300000000;  1997,  1491300000000;  1998,  1487200000000;  1999,  1449200000000;  2000,  1409900000000;  2001,  1385400000000;  2002,  1517700000000;  2003,  1513200000000;  2004,  1534900000000;  2005,  1467300000000]; //  land use data:         http://cdiac.ornl.gov/trends/landuse/houghton/houghton.html

  public
    KonnektorLuft konBioVS annotation (Placement(transformation(extent={{-56,
              -12},{-36,8}}), iconTransformation(extent={{-56,-12},{-36,8}})));
    KonnektorLuft konFlachVS annotation (Placement(transformation(extent={{-8,
              -48},{12,-28}}), iconTransformation(extent={{-8,-48},{12,-28}})));
  equation
    // hier Gleichungen eintragen
    der(m_C)=M_C*(J_c_bioatm + J_c_flachatm + Emission);
    x_CO2_atm = (m_C/M_C)/(m_ges_atm/M_Luft);
    Emission=1/M_C*DataFromTable(time,Tabelle_fossil) + 1/M_C*DataFromTable(time,Tabelle_landwirtschaft);

    x_CO2_gemessen = DataFromTable(time, x_CO2_Messdaten);
    x_CO2_berechnet = x_CO2_atm*1000000;
    x_CO2_delta = abs(x_CO2_gemessen - x_CO2_berechnet);
    x_CO2_max = max(x_CO2_max,x_CO2_delta);


    konBioVS.J = J_c_bioatm;
    konBioVS.x = x_CO2_atm;
    konFlachVS.J = J_c_flachatm;
    konFlachVS.x = x_CO2_atm;
  end Atmosphaere;

  model BioAtmVS "Kopplungssystem Biosphaere Atmosphaere"
  // Parameter
    parameter MolarFlowRate k_atm_bio =   2e18; // mol/Jahr
    // Konnektoren

    KonnektorLuft konBio annotation (Placement(transformation(extent={{-64,-2},
              {-44,18}}), iconTransformation(extent={{-64,-2},{-44,18}})));
    KonnektorLuft konAtm annotation (Placement(transformation(extent={{42,-8},{
              62,12}}), iconTransformation(extent={{42,-8},{62,12}})));
  equation
    // Gleichungen (bitte ergänzen)
    0 = M_C*(konBio.J + konAtm.J);
    konBio.J = k_atm_bio*(-konAtm.x + konBio.x);
   //Die Verknüpfungsgleichung genügt der Form:
   // J = k_atm_bio * (x_C_atm-x_C_bio)
   //Achten Sie auf die Fließrichtung! Der Stoffstrom muss immer vom Speichersystem mit dem höreren Molanteil
   //zum Speichersystem mit niedrigerem Molanteil gerichtet sein.
    annotation (Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,
              -100},{100,100}}), graphics={
          Rectangle(
            extent={{-28,60},{12,-20}},
            lineColor={0,0,255},
            fillColor={0,0,255},
            fillPattern=FillPattern.Solid),
          Text(
            extent={{-66,-52},{54,-92}},
            lineColor={0,0,255},
            textString="BioAtmVS"),
          Ellipse(extent={{-48,-50},{32,-92}}, lineColor={0,0,255}),
          Line(
            points={{-8,-20},{-8,-50}},
            color={0,0,255},
            smooth=Smooth.None)}),Diagram(coordinateSystem(preserveAspectRatio=true,
                    extent={{-100,-100},{100,100}}), graphics));
  end BioAtmVS;

  connector KonnektorLuft
    // Gleichungen ergaenzen
    flow MolarFlowRate J;
    MoleFraction x;
  end KonnektorLuft;

  function DataFromTable
    // Linear interpolation of data
    // diese Tabelle benoetigen Sie erst in Labor 6 und 7
    input Real u "input value (first column of table)";
    input Real table[:, :] "table to be interpolated";
    output Real y "interpolated input value (icol column of table)";
  protected
    Integer i;
    Integer n "number of rows of table";
    Real u1;
    Real u2;
    Real y1;
    Real y2;
    Real alpha1;
    Real alpha2;
  algorithm
    n := size(table, 1);
    if u <= table[1, 1] then
      y := table[1, 2];
    elseif u < table[n, 1] then
      i := 2;
      while i < n and u >= table[i, 1] loop
        i := i + 1;
      end while;
      i := i - 1;
      u1 := table[i, 1];
      y1 := table[i, 2];
      u2 := table[i + 1, 1];
      y2 := table[i + 1, 2];
      alpha1 := (u2 - u) / (u2 - u1);
      alpha2 := (u - u1) / (u2 - u1);
      y := alpha1 * y1 + alpha2 * y2;
    else
      y := table[n, 2];
    end if;
  end DataFromTable;

  model TeilModell
    Biosphaere biosphaere;
    BioAtmVS bioAtmVS;
    Atmosphaere atmosphaere;
  equation
    connect(biosphaere.konAtmVS, bioAtmVS.konBio);
    connect(bioAtmVS.konAtm, atmosphaere.konBioVS);
  end TeilModell;

  connector KonnektorWasser
   flow MolarFlowRate J;
   Concentration c;
  end KonnektorWasser;

  model FlacheOzeanschicht
    Mass m_C(start = m_C_start);
    parameter Mass m_C_start = 890*10^12;
    MolarFlowRate J_c_atmflach;
    MolarFlowRate J_c_tiefflach;
    Real pH;
    Real pH_gemessen;
    Real pH_delta;
    Real max_pH;

    constant Real K1 = 4.3E-4;
    constant Real K2 = 5.61E-8;
    constant Real Kb = 1.881E-6;
    constant Real Kw = 6.46E-9;
    parameter Concentration B = 0.409 "Borkonzentration in mol/m^3";
    parameter Concentration A = 2.324 "Elektroneutralitätskonsante in mol/m^3";
    Concentration c_CO2_aq(start = 0.00942);
    Concentration c_HCO3(start = 2.01125);
    Concentration c_CO3(start = 0.05602);
    Concentration c_H(start = 2.0142e-6);
    Concentration c_OH(start = 0.0032207);
    Concentration c_BOH3(start = 0.211493);
    Concentration c_BOH4(start = 0.19751);
    Concentration c_C "Gesamt-Kohlenstoff-Konzentration";

  protected
    constant Real pH_Messdaten[ :, :] = [1751,  8.7;  1785,  8.69;  1820,  8.68;  1870,  8.65;  1900,  8.63;  1970,  8.6;  2004,  8.59];

    KonnektorWasser konnektorAtmVS annotation (Placement(transformation(extent=
              {{-12,32},{8,52}}), iconTransformation(extent={{-12,32},{8,52}})));
    KonnektorWasser konnektorTiefVS annotation (Placement(transformation(extent=
             {{-8,-28},{12,-8}}), iconTransformation(extent={{-8,-28},{12,-8}})));
  equation

    der(m_C) = M_C*(J_c_atmflach + J_c_tiefflach);
    c_C = M_C^(-1)*m_C*V_flach^(-1);
    pH = -Modelica.Math.log10(c_H/1000);

    pH_gemessen = DataFromTable(time, pH_Messdaten);
    pH_delta = abs(pH_gemessen - pH);
    max_pH = max(max_pH, pH_delta);

    0 = c_CO2_aq + c_HCO3 + c_CO3 - c_C;
    0 = c_H * c_HCO3 - K1 * c_CO2_aq;
    0 = c_H * c_CO3 - K2 * c_HCO3;
    0 = c_H * c_OH - Kw;
    0 = (-Kb * c_BOH3) + c_H * c_BOH4;
    0 = c_BOH4 + c_BOH3 - B;
    0 = c_HCO3 + 2 * c_CO3 + c_BOH4 + c_OH - c_H - A;

    konnektorAtmVS.J = J_c_atmflach;
    konnektorAtmVS.c = c_CO2_aq;
    konnektorTiefVS.J = J_c_tiefflach;
    konnektorTiefVS.c = c_C;
  end FlacheOzeanschicht;

  model AtmFlachVS

    KonnektorLuft konAtm annotation (Placement(transformation(extent={{-12,46},{8,
              66}}), iconTransformation(extent={{-12,46},{8,66}})));
    KonnektorWasser konFlach annotation (Placement(transformation(extent={{-10,-14},
              {10,6}}), iconTransformation(extent={{-10,-14},{10,6}})));


    constant Real k_flach_atm = 1.48075*10^15;
    constant Pressure p_atm = 1.013*10^5;
    parameter Real k_Henry = 1.013*29.41*10^2;
    Pressure p_CO2_atm;
    Pressure p_CO2_flach;

  equation
    0 = konAtm.J + konFlach.J;
    konAtm.J = k_flach_atm*(p_CO2_atm - p_CO2_flach);
    p_CO2_atm = p_atm*konAtm.x;
    p_CO2_flach = k_Henry*konFlach.c;
  end AtmFlachVS;

  model TiefeOzeanschicht

    KonnektorWasser konnektorFlachVS annotation (Placement(transformation(extent={
              {-10,-8},{10,12}}), iconTransformation(extent={{-10,-8},{10,12}})));

    MolarFlowRate J_c_flachtief;
    Concentration c_C;
    Mass m_C(start=m_C_start);
    parameter Mass m_C_start = 36500*10^12;

  equation

    der(m_C) = M_C*J_c_flachtief;
    c_C = m_C/(M_C*(V_ozean - V_flach));
    J_c_flachtief = konnektorFlachVS.J;
    c_C = konnektorFlachVS.c;
  end TiefeOzeanschicht;

  model FlachtiefVS
    KonnektorWasser konFlach annotation (Placement(transformation(extent={{-10,22},
              {10,42}}), iconTransformation(extent={{-10,22},{10,42}})));
    KonnektorWasser konTief annotation (Placement(transformation(extent={{-10,-28},
              {10,-8}}), iconTransformation(extent={{-10,-28},{10,-8}})));


    constant Real k_tief_flach = 0.5*10^16;

  equation

    0 = konFlach.J + konTief.J;
    konTief.J = k_tief_flach*(konTief.c - konFlach.c);
  end FlachtiefVS;

  model CO2_Kreislauf
    Biosphaere biosphaere
      annotation (Placement(transformation(extent={{-86,54},{-66,74}})));
    BioAtmVS bioAtmVS
      annotation (Placement(transformation(extent={{-32,54},{-12,74}})));
    Atmosphaere atmosphaere
      annotation (Placement(transformation(extent={{26,52},{46,72}})));
    AtmFlachVS atmFlachVS
      annotation (Placement(transformation(extent={{24,18},{44,38}})));
    FlacheOzeanschicht flacheOzeanschicht
      annotation (Placement(transformation(extent={{26,-10},{46,10}})));
    FlachtiefVS flachtiefVS
      annotation (Placement(transformation(extent={{26,-42},{46,-22}})));
    TiefeOzeanschicht tiefeOzeanschicht
      annotation (Placement(transformation(extent={{28,-76},{48,-56}})));
  equation
    connect(biosphaere.konAtmVS, bioAtmVS.konBio) annotation (Line(points={{
            -75.6,64.2},{-51.8,64.2},{-51.8,64.8},{-27.4,64.8}}, color={0,0,0}));
    connect(bioAtmVS.konAtm, atmosphaere.konBioVS) annotation (Line(points={{
            -16.8,64.2},{7.6,64.2},{7.6,61.8},{31.4,61.8}}, color={0,0,0}));
    connect(atmosphaere.konFlachVS, atmFlachVS.konAtm) annotation (Line(points=
            {{36.2,58.2},{36.2,46.1},{33.8,46.1},{33.8,33.6}}, color={0,0,0}));
    connect(atmFlachVS.konFlach, flacheOzeanschicht.konnektorAtmVS) annotation (
       Line(points={{34,27.6},{35.8,27.6},{35.8,4.2}}, color={0,0,0}));
    connect(flacheOzeanschicht.konnektorTiefVS, flachtiefVS.konFlach)
      annotation (Line(points={{36.2,-1.8},{36.2,-15.9},{36,-15.9},{36,-28.8}},
          color={0,0,0}));
    connect(flachtiefVS.konTief, tiefeOzeanschicht.konnektorFlachVS)
      annotation (Line(points={{36,-33.8},{38,-33.8},{38,-65.8}}, color={0,0,0}));
    annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
          coordinateSystem(preserveAspectRatio=false)));
  end CO2_Kreislauf;
  annotation (uses(Modelica(version="3.2.2")),
                                             DymolaStoredErrors);
end Package_CO2_Kreislauf;
