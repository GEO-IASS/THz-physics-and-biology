function multiple_beam_interference(filename,L,duration,n_timepoints)
%calculates the time-evolution of the interfering electric fields in a
%material due to reflections at material boundaries.

%filename - string name of datafile from EO sampling
%L - total thickness of material in meters. (try 1E-3)
%duration - total time-domain duration in picoseconds. Increase for better 
%           resolution in the fourier transform to increase spacing between 
%           neighboring pulses (try 40)
%n_timepoints - number of timepoints. Increase for better temporal
%               resolution. (try 200)

%% Example parameters
% filename='data1';
% L=1E-3;
% duration=40;
% n_timepoints=200;

%%
% %sample frequency spectrum
% f=10^12.*[0,0.0390317189173466,0.0780634378346932,0.117095156752040,0.156126875669386,0.195158594586733,0.234190313504080,0.273222032421426,0.312253751338773,0.351285470256119,0.390317189173466,0.429348908090813,0.468380627008159,0.507412345925506,0.546444064842853,0.585475783760199,0.624507502677546,0.663539221594892,0.702570940512239,0.741602659429586,0.780634378346932,0.819666097264279,0.858697816181625,0.897729535098972,0.936761254016318,0.975792972933665,1.01482469185101,1.05385641076836,1.09288812968571,1.13191984860305,1.17095156752040,1.20998328643774,1.24901500535509,1.28804672427244,1.32707844318978,1.36611016210713,1.40514188102448,1.44417359994182,1.48320531885917,1.52223703777652,1.56126875669386,1.60030047561121,1.63933219452856,1.67836391344590,1.71739563236325,1.75642735128060,1.79545907019794,1.83449078911529,1.87352250803264,1.91255422694998,1.95158594586733,1.99061766478468,2.02964938370202,2.06868110261937,2.10771282153672,2.14674454045406,2.18577625937141,2.22480797828876,2.26383969720610,2.30287141612345,2.34190313504080,2.38093485395814,2.41996657287549,2.45899829179284,2.49803001071018,2.53706172962753,2.57609344854488,2.61512516746222,2.65415688637957,2.69318860529692,2.73222032421426,2.77125204313161,2.81028376204896,2.84931548096630,2.88834719988365,2.92737891880100,2.96641063771834,3.00544235663569,3.04447407555304,3.08350579447038,3.12253751338773,3.16156923230508,3.20060095122242,3.23963267013977,3.27866438905711,3.31769610797446,3.35672782689181,3.39575954580915,3.43479126472650,3.47382298364385,3.51285470256119,3.55188642147854,3.59091814039589,3.62994985931323,3.66898157823058,3.70801329714793,3.74704501606527,3.78607673498262,3.82510845389997,3.86414017281731,3.90317189173466,3.94220361065201,3.98123532956935,4.02026704848670,4.05929876740405,4.09833048632139,4.13736220523874,4.17639392415609,4.21542564307343,4.25445736199078,4.29348908090813,4.33252079982547,4.37155251874282,4.41058423766017,4.44961595657751,4.48864767549486,4.52767939441221,4.56671111332955,4.60574283224690,4.64477455116425,4.68380627008159,4.72283798899894,4.76186970791629,4.80090142683363,4.83993314575098,4.87896486466833,4.91799658358567,4.95702830250302,4.99606002142037,5.03509174033771,5.07412345925506,5.11315517817241,5.15218689708975,5.19121861600710,5.23025033492444,5.26928205384179,5.30831377275914,5.34734549167648,5.38637721059383,5.42540892951118,5.46444064842852,5.50347236734587,5.54250408626322,5.58153580518056,5.62056752409791,5.65959924301526,5.69863096193260,5.73766268084995,5.77669439976730,5.81572611868464,5.85475783760199,5.89378955651934,5.93282127543668,5.97185299435403,6.01088471327138,6.04991643218872,6.08894815110607,6.12797987002342,6.16701158894076,6.20604330785811,6.24507502677546,6.28410674569280,6.32313846461015,6.36217018352750,6.40120190244484,6.44023362136219,6.47926534027954,6.51829705919688,6.55732877811423,6.59636049703158,6.63539221594892,6.67442393486627,6.71345565378362,6.75248737270096,6.79151909161831,6.83055081053566,6.86958252945300,6.90861424837035,6.94764596728770,6.98667768620504,7.02570940512239,7.06474112403974,7.10377284295708,7.14280456187443,7.18183628079177,7.22086799970912,7.25989971862647,7.29893143754381,7.33796315646116,7.37699487537851,7.41602659429585,7.45505831321320,7.49409003213055,7.53312175104789,7.57215346996524,7.61118518888259,7.65021690779993,7.68924862671728,7.72828034563463,7.76731206455197,7.80634378346932,7.84537550238667,7.88440722130401,7.92343894022136,7.96247065913871,8.00150237805605,8.04053409697340,8.07956581589075,8.11859753480809,8.15762925372544,8.19666097264279,8.23569269156013,8.27472441047748,8.31375612939483,8.35278784831217,8.39181956722952,8.43085128614687,8.46988300506421,8.50891472398156,8.54794644289891,8.58697816181625,8.62600988073360,8.66504159965095,8.70407331856829,8.74310503748564,8.78213675640299,8.82116847532033,8.86020019423768,8.89923191315503,8.93826363207237,8.97729535098972,9.01632706990707,9.05535878882441,9.09439050774176,9.13342222665911,9.17245394557645,9.21148566449380,9.25051738341115,9.28954910232849,9.32858082124584,9.36761254016319,9.40664425908053,9.44567597799788,9.48470769691522,9.52373941583257,9.56277113474992,9.60180285366726,9.64083457258461,9.67986629150196,9.71889801041930,9.75792972933665,9.79696144825400,9.83599316717134,9.87502488608869,9.91405660500604,9.95308832392338,9.99212004284073];
% fft=[-7.68431140000000 + 0.00000000000000i;-2.99124486700845 + 1.32250871552102i;0.263332275205232 + 2.93270464060523i;-9.88127211786797 - 12.6264180651217i;-18.6171618520255 + 28.3491004245251i;47.2151126433741 + 0.215679370876840i;-42.3096381155865 - 55.8389640072140i;-34.0343085233934 + 81.2863473208535i;90.3833893079504 - 19.8212331153330i;-77.5697771186188 - 62.4583273514903i;-7.03473013964253 + 100.355264905308i;75.5251705272563 - 53.8471758507088i;-90.2299037381525 - 20.4454629657319i;35.5542430750676 + 79.4671871494594i;30.7960257618221 - 69.3440649762046i;-69.4227449586122 + 24.0862446738010i;57.1529897043432 + 36.4237191300412i;-10.0187830705961 - 59.6894810843269i;-36.8636823850763 + 43.1941768030251i;47.9373904192307 - 0.418520095023516i;-33.2786136121353 - 29.0622982208316i;-0.365086838288888 + 43.9232378878875i;28.4561119332142 - 26.2590703863163i;-39.1566215580018 - 0.275059380901252i;24.1782969700275 + 30.7309260028651i;4.87043166229598 - 36.4693177291302i;-33.3459212362049 + 21.9394694680181i;34.8461564729231 + 15.5452698238773i;-9.14635859799978 - 31.1061081214529i;-16.0503373588424 + 27.1171459866783i;30.0080615920436 - 4.60600350544521i;-23.7476338438741 - 19.1834232415222i;-2.53905388891483 + 31.9125481250975i;26.7870072417659 - 13.5767107413410i;-24.9473625778660 - 13.2952952447167i;0.944170694352486 + 25.9434781291222i;16.9827726685237 - 11.6864707629214i;-17.9245910375616 - 4.24769453016567i;5.45344640137369 + 17.0231054039579i;9.64277505582381 - 10.1120105446052i;-11.1258955995873 - 0.425822406214907i;5.03899700786467 + 8.34706690364561i;3.09390268516588 - 5.58898535225437i;-3.22820259261775 + 1.91963756144986i;3.56410209788042 - 1.19293057857945i;-5.67478896832688 - 2.03465306291185i;0.695965400668034 + 8.11549129056416i;6.78598008552211 - 4.36878472081181i;-7.62920897278490 - 2.76351298005818i;1.51078950568599 + 8.85852319266548i;7.29091220442158 - 5.29886646849602i;-7.83464917384238 - 4.26638042357488i;-1.04321369190560 + 8.23222163816504i;6.30042278286560 - 2.19090012570004i;-4.49827596786916 - 3.93936917125297i;-2.08266902339798 + 4.81009139868392i;3.10670041640729 - 0.101467782982880i;-2.42203080892934 - 1.37905006878490i;-0.636825017078434 + 3.28429071912590i;2.23856733986788 + 0.0578289526222442i;-1.15081136207405 - 1.08394170134687i;-0.582783245693680 + 1.71098917360178i;0.945289666198861 + 0.483464900289913i;-0.228489961133945 - 0.614426050252204i;-0.659981787460260 + 0.806481875272777i;0.0936785795360108 + 0.659419119005302i;0.159591095248907 + 0.127026078237876i;-0.267612728570541 + 0.423086184540366i;-0.0919338939128347 + 0.396197818504497i;0.0631759938895535 + 0.418337749291228i;0.0444446791430066 + 0.245076838687930i;-0.188762146877804 + 0.103646700026375i;-0.271074097424904 + 0.483271286055061i;0.154948471304109 + 0.384955073998956i;-0.154426012898987 + 0.0407671827096818i;-0.338660188072880 + 0.448728871981689i;0.133593728215086 + 0.404372165875115i;-0.186935871953988 + 0.0700105669933131i;-0.285545177225475 + 0.473097771632529i;0.0386745662079686 + 0.396035984324484i;-0.0570522626849090 + 0.142921940622712i;-0.361713634427019 + 0.464560458489490i;0.183681058143655 + 0.424806718999933i;-0.0396851798187674 + 0.141261166070473i;-0.205719791970592 + 0.260317513438420i;-0.123378162594163 + 0.403255337123140i;-0.00486971434477779 + 0.216122039606594i;-0.119903631887867 + 0.541178628107288i;0.0872937864982708 + 0.0658955943654850i;-0.0777229889740685 + 0.256533555748133i;-0.183923421293009 + 0.461077566553113i;0.161495980361813 + 0.0390366938058810i;-0.0873622613294778 + 0.312875293446074i;-0.129889325328421 + 0.185902606960333i;-0.00809947563497104 + 0.0392682100964645i;-0.259045569048491 + 0.316420476191891i;-0.180369511848021 + 0.285380290359401i;-0.00968807767868363 + 0.206148938064378i;-0.252555470478798 + 0.378047147276692i;0.0452499273816649 + 0.373977367698045i;0.0380073946098234 + 0.145099236355622i;-0.175763434410360 + 0.220788301185923i;-0.00422652311937366 + 0.385619414006796i;-0.00815795702502231 + 0.0711215279354791i;-0.124148031755106 + 0.293764544165900i;-0.0641574038439754 + 0.255909859422600i;-0.00556301972240814 + 0.240281931816503i;-0.0483933425695348 + 0.214378922137154i;0.0213686924173118 + 0.225244329914716i;-0.119199943115392 + 0.139694760954069i;-0.0652853514141150 + 0.268989572793712i;0.0775793166573187 + 0.298837859573704i;-0.0965935494781469 + 0.0821258340355389i;0.150679597151839 + 0.268985371031720i;-0.0915730897906766 - 0.00104866170820728i;-0.116939083785985 + 0.174592644426955i;0.0474342403646730 + 0.252545935190825i;-0.0101718962087887 - 0.0605721117402442i;-0.270935376795265 + 0.204205809801184i;0.0916357157643279 + 0.218598649544610i;-0.156598925325665 + 0.00891539628859306i;-0.121392977020804 + 0.300326480944900i;0.0690998738828501 + 0.0723595026244848i;-0.217190472571996 + 0.0950772864156563i;-0.0856066186111075 + 0.234413749239758i;-0.0149506626161053 + 0.173811775856967i;-0.169125706159674 + 0.0892587437412400i;0.0170715228661466 + 0.287516233764960i;-0.146000900000003 + 0.0882144999999979i;-0.00279937416980641 + 0.238610122851377i;0.0483230647432467 + 0.196178973825270i;-0.103823843295325 - 0.0293660170623977i;-0.0293890842479563 + 0.265518113834190i;-0.0125714133281962 + 0.0731621964291547i;-0.0617391324705654 + 0.0597260773882748i;-0.0980998311233492 + 0.182372712509075i;0.0426194074345974 + 0.0318377116325976i;-0.240869692340995 + 0.149956346793452i;0.129119645741397 + 0.0969759510971677i;-0.253939594655193 + 0.0428136715490357i;-0.0469893685579805 + 0.193523996197221i;-0.0889389002551919 + 0.151251943590676i;-0.0189172043631114 + 0.112610254601503i;-0.0655356989614297 + 0.235927772683196i;0.161343299010600 - 0.0476243027335297i;-0.235753745643886 - 0.00430035434264076i;-0.0750776427949802 + 0.170524709005297i;-0.0911920404616339 + 0.00917075975493342i;-0.144519015449902 + 0.221970046922181i;0.0577808643900802 + 0.0964888299296189i;-0.129648535218664 - 0.0407397328586310i;-0.152639562471431 + 0.234658964220168i;0.0509986071265560 + 0.0700578554055165i;-0.143242010510472 + 0.0419923827264421i;-0.0521848814289259 + 0.207334463137369i;0.102523437297638 - 0.0307029931425293i;-0.283114488960531 + 0.00625573643815480i;0.0175735836699609 + 0.203050991774455i;0.00389811819691799 - 0.0399184900758209i;-0.287712296701068 + 0.0138346101034665i;0.0523455310126941 + 0.193801087821052i;-0.145541662569227 - 0.00197602796528651i;-0.108945223706626 + 0.0264398368128727i;-0.0692856971049486 + 0.189074844215130i;-0.117227162112974 - 0.0629115189315561i;-0.112003526935171 + 0.206808406849244i;0.0320648140627744 - 0.00720448125230710i;-0.213290497432905 - 0.0439236834755201i;-0.195453726933212 + 0.173447019293767i;0.0154829079113428 + 0.122133991686679i;-0.213521098914595 - 0.000357817158951113i;-0.0145541150444394 + 0.232409177716810i;-0.0316730013534838 - 0.00938900645907398i;-0.129453761540823 + 0.00166280690709547i;-0.0978473840950472 + 0.117682705953345i;-0.137051690202617 - 0.00321627317600104i;-0.182569137945366 + 0.105982933945932i;-0.0309740789843358 + 0.227884045478646i;-0.102673502946303 - 0.0540553148335781i;-0.0455973257632960 + 0.181068214346529i;-0.0956743206890487 + 0.0282306274923163i;-0.118971372277227 + 0.0165214833026894i;-0.0873450720786357 + 0.250622021999858i;0.0759570732594760 - 0.0173525223781916i;-0.181044211051287 - 0.0318968196638034i;-0.0127544091641436 + 0.172996909367625i;-0.0649219141409918 - 0.0586949931632457i;-0.145705021007980 - 0.0376985030268818i;-0.0921363263087114 + 0.208246692258289i;-0.0970416929091012 - 0.147534287570444i;-0.162898566922913 + 0.153052638796315i;-0.120240776790717 + 0.0858253288625639i;-0.0555988125397386 + 0.0106242752727794i;-0.201936381077959 + 0.165094287675053i;0.0931717893124268 + 0.101655869943303i;-0.114528090081965 - 0.0541234452678751i;-0.0806442225362324 + 0.0793626201704141i;-0.0412439142315111 - 0.00389356514656726i;-0.187735693121700 - 0.00648791749642430i;-0.0599881560855533 + 0.129769493401965i;-0.0460722025241429 - 0.0539044967859612i;-0.211433210439599 + 0.0461436187362505i;-0.0579976427693587 + 0.0536281912790512i;-0.148541713841824 + 0.0640835001812057i;-0.0835581729909631 + 0.0831772477948685i;-0.0144576092236888 + 0.0227979199194205i;-0.155521124626724 - 0.0406371633109000i;-0.138573196171483 + 0.126361682180610i;-0.00605920213991840 - 0.0180741010018335i;-0.189094571897913 - 0.0141707882707696i;-0.145906290198955 + 0.111492484860331i;-0.0245280374830403 - 0.00113527599889646i;-0.234314649231749 - 0.0135476085824248i;-0.141408122301698 + 0.189336910419880i;-0.0276595463815029 + 0.00445725845311018i;-0.198065627422160 + 0.0988834029247223i;-0.00509776589133981 + 0.120671089221994i;-0.100970078989519 + 0.0158129611336006i;-0.0443641035575288 + 0.0608489920144084i;-0.0846180575828814 + 0.0614168553366951i;-0.0518819405156998 - 0.0256129443102209i;-0.127008414244078 + 0.0289317911081692i;-0.0702183741537512 + 0.0726343718006812i;-0.140284808367700 - 0.0474408041669459i;-0.0702021302498439 + 0.112981322559182i;-0.108662507478215 + 0.0223392076706581i;-0.112780526296618 - 0.0273257215999121i;-0.131436859545699 + 0.171204042486648i;0.0164764815355696 + 0.0108783620680164i;-0.144186923369361 - 0.0522910747677674i;-0.149201117217480 + 0.125945737396098i;0.0108930393008997 + 0.0786472503939244i;-0.175443462416551 - 0.0444376546237013i;0.0318652892465501 + 0.220078164851894i;-0.00174033676815100 - 0.138727726857146i;-0.161068146233099 - 0.00928818958823641i;-0.0752225576978205 + 0.0764304903483222i;-0.0514444803148386 - 0.0495238679409233i;-0.211153253188371 + 0.0558030678060071i;0.0451956940137226 + 0.0639866518711294i;-0.138413878320584 - 0.0253131209947668i;-0.110260821353044 + 0.0201929111267560i;0.00861291202344638 + 0.0855607427540193i;-0.177808932932230 - 0.112685879661981i;-0.0490632092575751 + 0.162924669641594i;-0.0478530565083943 - 0.0461730199436587i;-0.0931838377999017 - 0.0140000633621185i;-0.0652036277317620 + 0.0824819738892302i;-0.0683680725350300 - 0.106336847310271i;-0.123743906194481 + 0.0501001760414610i;-0.0831593639513741 + 0.0474163630045474i;-0.0567923112755082 - 0.108580319275914i;-0.219825563519223 + 0.127730911409170i;0.0436858022639957 + 0.0470238049673508i;-0.120159423297668 - 0.0455030933381564i;-0.0461437373379925 + 0.0821666683658612i;-0.0266200000000008 + 0.00000000000000i];
% fft=fft';

[t wave]=single_data2structure(filename);

%zero-pad the time-domain for better resolution on frequency spectrum. Use
%a larger t_max to avoid interference from the previous main pulse
[f fft t_max]=zero_padded_waveform(duration,t.(sprintf('%s',filename)),wave.(sprintf('%s',filename))); 
f=10^12.*f;
fft=fft';

%L=1E-3; %thickness of coverslip (m)
y=linspace(0,L,length(f));

t=10^-12.*linspace(0,4*t_max,n_timepoints); %more points=better temporal resolution

c=2.9979E8; %speed of light (m/s)

E0=abs(fft)./max(abs(fft));
sum_E0=sum(E0);
phase=angle(fft);

w=2.*pi.*f;

%% complex index of refraction n=nr+i*ni

%assume air has n=1
n_air=ones(1,length(f));

%water from refractiveindex.info (or something like that...google it)
%first entry manually added for interpolation
f_water_temp=flipud([10.338,9.993,9.368,8.817,8.328,7.889,7.495,7.138,6.813,6.517,6.246,5.996,4.997,4.283,3.747,3.331,2.998,2.725,2.498,2.306,2.141,1.999,1.874,1.763,1.666,1.578,1.499,0.000]')';
n_water_temp=(4/3).*flipud([1.551,1.551,1.546,1.536,1.527,1.522,1.519,1.522,1.530,1.541,1.555,1.587,1.703,1.821,1.886,1.924,1.957,1.966,2.004,2.036,2.056,2.069,2.081,2.094,2.107,2.119,2.130,3.000]')';
n_water=interp1(f_water_temp,n_water_temp,f.*10^-12);

%data for SiO2 read from pg. 41 of Fox - Optical properties of solids
%first entry manually added for interpolation
f_temp=[0,0.5,0.6,0.7,0.8,0.9,1,2,3,4,5,6,7,8,9,10];
nr_temp=[1.98,1.98,1.98,1.98,1.98,1.98,1.98,1.99,1.99,2.01,2.06,2.07,2.1,2.2,2.5,3];
ni_temp=[0.009,0.0090,0.0080,0.0080,0.0070,0.0070,0.0060,0.0100,0.0190,0.0210,0.0300,0.0400,0.0500,0.1000,0.1500,0.3000];
nr=interp1(f_temp,nr_temp,f.*10^-12);
ni=interp1(f_temp,ni_temp,f.*10^-12);

% %hypothetical material
% %first entry manually added for interpolation
% f_temp=[0 0.3,0.4,0.5,0.6,0.7,0.8,0.9,1,1.1,1.2,1.3,1.4,1.5,2,4,6,8,10];
% nr_temp=[2.7 2.76,2.79,2.8,2.81,2.83,2.85,2.87,2.9,2.95,3,3.1,3.2,3.4,3.6,3.8,4,4.5,5];
% ni_temp=[0.022
% 0.022,0.025,0.04,0.05,0.07,0.09,0.12,0.15,0.16,0.17,0.18,0.19,0.2,0.21,0.22,0.23,0.24,0.25];
% nr=interp1(f_temp,nr_temp,f.*10^-12);
% ni=interp1(f_temp,ni_temp,f.*10^-12);


% %check complex refractive index
% figure
% subplot(1,3,1)
% plot(f_temp.*10^12, nr_temp,'bo')
% hold on
% plot(f,nr,'b--')
% hold off
% xlabel('Frequency (Hz)');ylabel('Refractive index');legend('Data','interpolation')
% title('Coverslip refractive index')
% subplot(1,3,2)
% plot(f_temp.*10^12, ni_temp,'ro')
% hold on
% plot(f, ni,'r--')
% hold off
% xlabel('Frequency (Hz)');ylabel('Extinction Coefficient');legend('Data','interpolation')
% title('SiO2 extinction coefficient')
% subplot(1,3,3)
% plot(f_water_temp.*10^12, n_water_temp,'ko')
% hold on
% plot(f, n_water,'k--')
% hold off
% xlabel('Frequency (Hz)');ylabel('Extinction Coefficient');legend('Data','interpolation')
% xlim([0 max(f)])
% title('Water refractive index')

%% amplitude transmission/reflection coefficients (from Hecht pg. 114)
 %t12 is transmission from air to SiO2
 %r21 is reflection at air/SiO2 interface
 %r23 is reflection at SiO2/water interface
 
t12=2.*n_air./(n_air+nr);
r21=(nr-n_air)./(nr+n_air);
r23=(nr-n_water)./(nr+n_water);

%% Calculate field amplitude at each frequency

%with time dependence
E0_MBI=zeros(length(y),length(f),length(t));
wait = waitbar(0,'Calculating complex electric field.');
for j=1:length(t)
    for k=1:length(f)
        E0_MBI(:,k,j)=E0(k).*exp(1i*w(k).*t(j)).*t12(k).*((exp(-w(k).*y./c.*(ni(k)+1i*nr(k)))+r23(k).*exp(w(k).*y./c.*(ni(k)+1i*nr(k))).*exp(-2.*w(k).*L./c.*(ni(k)+1i*nr(k))))./(1-r23(k).*r21(k).*exp(-2.*w(k).*L./c.*(ni(k)+1i*nr(k))))).*exp(1i*phase(k));        
    end
    %fprintf('%i of %i\n',j,length(t))  %poor man's progress bar    
    wait=waitbar(j/length(t),wait);
end
close(wait);
wait=waitbar(0.6,'Loading plots');
close(wait);
E0_MBI_tot=sum(E0_MBI,2); %sum contribution from each frequency
E0_MBI_tot=squeeze(E0_MBI_tot); %should have E(y,t) now

%organize plotting data into structures
MBI_plot_struct=struct('E0_MBI',E0_MBI_tot,'t',t,'y',y,'sum_E0',sum_E0);
wait=waitbar(1,'Loading plots');
close(wait);

%% Display plots
%movie of time evolution
MBI_dynamic_plot(MBI_plot_struct)
