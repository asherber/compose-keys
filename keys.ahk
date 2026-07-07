#Requires AutoHotkey v2.0

::  ::cp("{ASC 0160}")  ; No-break space
::!!::cp("¡")   ; Inverted exclamation mark
::|c::cp("¢")   ; Cent sign
::c|::cp("¢")   ; Cent sign
::c/::cp("¢")   ; Cent sign
::/c::cp("¢")   ; Cent sign
::L-::cp("£")   ; Pound sign
::-L::cp("£")   ; Pound sign
::ox::cp("¤")   ; Currency sign
::xo::cp("¤")   ; Currency sign
::Y=::cp("¥")   ; Yen sign
::=Y::cp("¥")   ; Yen sign
::!^::cp("¦")   ; Broken bar
::so::cp("§")   ; Section sign
::os::cp("§")   ; Section sign
::oc::cp("©")   ; Copyright sign
::oC::cp("©")   ; Copyright sign
::Oc::cp("©")   ; Copyright sign
::OC::cp("©")   ; Copyright sign
::^_::cp("ª")   ; Feminine ordinal indicator
::<<::cp("«")   ; Left-pointing double angle quotation mark
::,-::cp("¬")   ; Not sign
::-,::cp("¬")   ; Not sign
::or::cp("®")   ; Registered sign
::oR::cp("®")   ; Registered sign
::Or::cp("®")   ; Registered sign
::OR::cp("®")   ; Registered sign
::oo::cp("°")   ; Degree sign
::+-::cp("±")   ; Plus-minus sign
::^2::cp("²")   ; Superscript two
::^3::cp("³")   ; Superscript three
::mu::cp("µ")   ; Micro sign
::p!::cp("¶")   ; Pilcrow sign
::P!::cp("¶")   ; Pilcrow sign
::PP::cp("¶")   ; Pilcrow sign
::..::cp("·")   ; Middle dot
::, ::cp("¸")   ; Cedilla
:: ,::cp("¸")   ; Cedilla
::^1::cp("¹")   ; Superscript one
::.o::cp("º")   ; Masculine ordinal indicator
::>>::cp("»")   ; Right-pointing double angle quotation mark
::14::cp("¼")   ; Vulgar fraction one quarter
::12::cp("½")   ; Vulgar fraction one half
::34::cp("¾")   ; Vulgar fraction three quarters
::??::cp("¿")   ; Inverted question mark
::``A::cp("À")  ; Capital letter A with grave
::'A::cp("Á")   ; Capital letter A with acute
::^A::cp("Â")   ; Capital letter A with circumflex
::~A::cp("Ã")   ; Capital letter A with tilde
::"A::cp("Ä")   ; Capital letter A with diaeresis
::oA::cp("Å")   ; Capital letter A with ring above
::AE::cp("Æ")   ; Capital letter ae
::,C::cp("Ç")   ; Capital letter C with cedilla
::``E::cp("È")  ; Capital letter E with grave
::'E::cp("É")   ; Capital letter E with acute
::^E::cp("Ê")   ; Capital letter E with circumflex
::"E::cp("Ë")   ; Capital letter E with diaeresis
::``I::cp("Ì")  ; Capital letter I with grave
::'I::cp("Í")   ; Capital letter I with acute
::^I::cp("Î")   ; Capital letter I with circumflex
::"I::cp("Ï")   ; Capital letter I with diaeresis
::DH::cp("Ð")   ; Capital letter eth
::~N::cp("Ñ")   ; Capital letter N with tilde
::``O::cp("Ò")  ; Capital letter O with grave
::'O::cp("Ó")   ; Capital letter O with acute
::^O::cp("Ô")   ; Capital letter O with circumflex
::~O::cp("Õ")   ; Capital letter O with tilde
::"O::cp("Ö")   ; Capital letter O with diaeresis
::xx::cp("×")   ; Multiplication sign
::/O::cp("Ø")   ; Capital letter O with stroke
::``U::cp("Ù")  ; Capital letter U with grave
::'U::cp("Ú")   ; Capital letter U with acute
::^U::cp("Û")   ; Capital letter U with circumflex
::"U::cp("Ü")   ; Capital letter U with diaeresis
::'Y::cp("Ý")   ; Capital letter Y with acute
::TH::cp("Þ")   ; Capital letter thorn
::ss::cp("ß")   ; Small letter sharp s
::``a::cp("à")  ; Small letter a with grave
::'a::cp("á")   ; Small letter a with acute
::^a::cp("â")   ; Small letter a with circumflex
::~a::cp("ã")   ; Small letter a with tilde
::"a::cp("ä")   ; Small letter a with diaeresis
::oa::cp("å")   ; Small letter a with ring above
::ae::cp("æ")   ; Small letter ae
::,c::cp("ç")   ; Small letter c with cedilla
::``e::cp("è")  ; Small letter e with grave
::'e::cp("é")   ; Small letter e with acute
::^e::cp("ê")   ; Small letter e with circumflex
::"e::cp("ë")   ; Small letter e with diaeresis
::``i::cp("ì")  ; Small letter i with grave
::'i::cp("í")   ; Small letter i with acute
::^i::cp("î")   ; Small letter i with circumflex
::"i::cp("ï")   ; Small letter i with diaeresis
::dh::cp("ð")   ; Small letter eth
::~n::cp("ñ")   ; Small letter n with tilde
::``o::cp("ò")  ; Small letter o with grave
::'o::cp("ó")   ; Small letter o with acute
::^o::cp("ô")   ; Small letter o with circumflex
::~o::cp("õ")   ; Small letter o with tilde
::"o::cp("ö")   ; Small letter o with diaeresis
:::-::cp("÷")   ; Division sign
::-`:::cp("÷")  ; Division sign
::/o::cp("ø")   ; Small letter o with stroke
::``u::cp("ù")  ; Small letter u with grave
::'u::cp("ú")   ; Small letter u with acute
::^u::cp("û")   ; Small letter u with circumflex
::"u::cp("ü")   ; Small letter u with diaeresis
::'y::cp("ý")   ; Small letter y with acute
::th::cp("þ")   ; Small letter thorn
::"y::cp("ÿ")   ; Small letter y with diaeresis
::_A::cp("Ā")   ; Capital letter A with macron
::_a::cp("ā")   ; Small letter a with macron
::UA::cp("Ă")   ; Capital letter A with breve
::bA::cp("Ă")   ; Capital letter A with breve
::Ua::cp("ă")   ; Small letter a with breve
::ba::cp("ă")   ; Small letter a with breve
::;A::cp("Ą")   ; Capital letter A with ogonek
::;a::cp("ą")   ; Small letter a with ogonek
::'C::cp("Ć")   ; Capital letter C with acute
::'c::cp("ć")   ; Small letter c with acute
::^C::cp("Ĉ")   ; Capital letter C with circumflex
::^c::cp("ĉ")   ; Small letter c with circumflex
::cC::cp("Č")   ; Capital letter C with caron
::cc::cp("č")   ; Small letter c with caron
::cD::cp("Ď")   ; Capital letter D with caron
::cd::cp("ď")   ; Small letter d with caron
::-D::cp("Đ")   ; Capital letter D with stroke
::/D::cp("Đ")   ; Capital letter D with stroke
::-d::cp("đ")   ; Small letter d with stroke
::/d::cp("đ")   ; Small letter d with stroke
::_E::cp("Ē")   ; Capital letter E with macron
::_e::cp("ē")   ; Small letter e with macron
::UE::cp("Ĕ")   ; Capital letter E with breve
::bE::cp("Ĕ")   ; Capital letter E with breve
::Ue::cp("ĕ")   ; Small letter e with breve
::be::cp("ĕ")   ; Small letter e with breve
::;E::cp("Ę")   ; Capital letter E with ogonek
::;e::cp("ę")   ; Small letter e with ogonek
::cE::cp("Ě")   ; Capital letter E with caron
::ce::cp("ě")   ; Small letter e with caron
::^G::cp("Ĝ")   ; Capital letter G with circumflex
::^g::cp("ĝ")   ; Small letter g with circumflex
::UG::cp("Ğ")   ; Capital letter G with breve
::bG::cp("Ğ")   ; Capital letter G with breve
::Ug::cp("ğ")   ; Small letter g with breve
::bg::cp("ğ")   ; Small letter g with breve
::,G::cp("Ģ")   ; Capital letter G with cedilla
::,g::cp("ģ")   ; Small letter g with cedilla
::^H::cp("Ĥ")   ; Capital letter H with circumflex
::^h::cp("ĥ")   ; Small letter h with circumflex
::/H::cp("Ħ")   ; Capital letter H with stroke
::/h::cp("ħ")   ; Small letter h with stroke
::~I::cp("Ĩ")   ; Capital letter I with tilde
::~i::cp("ĩ")   ; Small letter i with tilde
::_I::cp("Ī")   ; Capital letter I with macron
::_i::cp("ī")   ; Small letter i with macron
::UI::cp("Ĭ")   ; Capital letter I with breve
::bI::cp("Ĭ")   ; Capital letter I with breve
::Ui::cp("ĭ")   ; Small letter i with breve
::bi::cp("ĭ")   ; Small letter i with breve
::;I::cp("Į")   ; Capital letter I with ogonek
::;i::cp("į")   ; Small letter i with ogonek
::i.::cp("ı")   ; Small letter dotless i
::^J::cp("Ĵ")   ; Capital letter J with circumflex
::^j::cp("ĵ")   ; Small letter j with circumflex
::,K::cp("Ķ")   ; Capital letter K with cedilla
::,k::cp("ķ")   ; Small letter k with cedilla
::kk::cp("ĸ")   ; Small letter kra
::'L::cp("Ĺ")   ; Capital letter L with acute
::'l::cp("ĺ")   ; Small letter l with acute
::,L::cp("Ļ")   ; Capital letter L with cedilla
::,l::cp("ļ")   ; Small letter l with cedilla
::cL::cp("Ľ")   ; Capital letter L with caron
::cl::cp("ľ")   ; Small letter l with caron
::/L::cp("Ł")   ; Capital letter L with stroke
::/l::cp("ł")   ; Small letter l with stroke
::'N::cp("Ń")   ; Capital letter N with acute
::'n::cp("ń")   ; Small letter n with acute
::,N::cp("Ņ")   ; Capital letter N with cedilla
::,n::cp("ņ")   ; Small letter n with cedilla
::cN::cp("Ň")   ; Capital letter N with caron
::cn::cp("ň")   ; Small letter n with caron
::NG::cp("Ŋ")   ; Capital letter eng
::ng::cp("ŋ")   ; Small letter eng
::_O::cp("Ō")   ; Capital letter O with macron
::_o::cp("ō")   ; Small letter o with macron
::UO::cp("Ŏ")   ; Capital letter O with breve
::BO::cp("Ŏ")   ; Capital letter O with breve
::uo::cp("ŏ")   ; Small letter o with breve
::bo::cp("ŏ")   ; Small letter o with breve
::=O::cp("Ő")   ; Capital letter O with double acute
::=o::cp("ő")   ; Small letter o with double acute
::OE::cp("Œ")   ; Capital ligature oe
::oe::cp("œ")   ; Small ligature oe
::'R::cp("Ŕ")   ; Capital letter R with acute
::'r::cp("ŕ")   ; Small letter r with acute
::,R::cp("Ŗ")   ; Capital letter R with cedilla
::,r::cp("ŗ")   ; Small letter r with cedilla
::cR::cp("Ř")   ; Capital letter R with caron
::cr::cp("ř")   ; Small letter r with caron
::'S::cp("Ś")   ; Capital letter S with acute
::'s::cp("ś")   ; Small letter s with acute
::^S::cp("Ŝ")   ; Capital letter S with circumflex
::^s::cp("ŝ")   ; Small letter s with circumflex
::,S::cp("Ş")   ; Capital letter S with cedilla
::,s::cp("ş")   ; Small letter s with cedilla
::cS::cp("Š")   ; Capital letter S with caron
::cs::cp("š")   ; Small letter s with caron
::,T::cp("Ţ")   ; Capital letter T with cedilla
::,t::cp("ţ")   ; Small letter t with cedilla
::cT::cp("Ť")   ; Capital letter T with caron
::ct::cp("ť")   ; Small letter t with caron
::/T::cp("Ŧ")   ; Capital letter T with stroke
::/t::cp("ŧ")   ; Small letter t with stroke
::~U::cp("Ũ")   ; Capital letter U with tilde
::~u::cp("ũ")   ; Small letter u with tilde
::_U::cp("Ū")   ; Capital letter U with macron
::_u::cp("ū")   ; Small letter u with macron
::UU::cp("Ŭ")   ; Capital letter U with breve
::bU::cp("Ŭ")   ; Capital letter U with breve
::Uu::cp("ŭ")   ; Small letter u with breve
::"b::cp("ŭ")   ; Small letter u with breve
::oU::cp("Ů")   ; Capital letter U with ring above
::ou::cp("ů")   ; Small letter u with ring above
::=U::cp("Ű")   ; Capital letter U with double acute
::=u::cp("ű")   ; Small letter u with double acute
::;U::cp("Ų")   ; Capital letter U with ogonek
::;u::cp("ų")   ; Small letter u with ogonek
::^W::cp("Ŵ")   ; Capital letter W with circumflex
::^w::cp("ŵ")   ; Small letter w with circumflex
::^Y::cp("Ŷ")   ; Capital letter Y with circumflex
::^y::cp("ŷ")   ; Small letter y with circumflex
::"Y::cp("Ÿ")   ; Capital letter Y with diaeresis
::'Z::cp("Ź")   ; Capital letter Z with acute
::'z::cp("ź")   ; Small letter z with acute
::cZ::cp("Ž")   ; Capital letter Z with caron
::cz::cp("ž")   ; Small letter z with caron
::fs::cp("ſ")   ; Small letter long s
::/b::cp("ƀ")   ; Small letter b with stroke
::/I::cp("Ɨ")   ; Capital letter I with stroke
::/Z::cp("Ƶ")   ; Capital letter Z with stroke
::/z::cp("ƶ")   ; Small letter z with stroke
::cA::cp("Ǎ")   ; Capital letter A with caron
::ca::cp("ǎ")   ; Small letter a with caron
::cI::cp("Ǐ")   ; Capital letter I with caron
::ci::cp("ǐ")   ; Small letter i with caron
::cO::cp("Ǒ")   ; Capital letter O with caron
::co::cp("ǒ")   ; Small letter o with caron
::cU::cp("Ǔ")   ; Capital letter U with caron
::cu::cp("ǔ")   ; Small letter u with caron
::/G::cp("Ǥ")   ; Capital letter G with stroke
::/g::cp("ǥ")   ; Small letter g with stroke
::cG::cp("Ǧ")   ; Capital letter G with caron
::cg::cp("ǧ")   ; Small letter g with caron
::cK::cp("Ǩ")   ; Capital letter K with caron
::ck::cp("ǩ")   ; Small letter k with caron
::;O::cp("Ǫ")   ; Capital letter O with ogonek
::;o::cp("ǫ")   ; Small letter o with ogonek
::cj::cp("ǰ")   ; Small letter j with caron
::'G::cp("Ǵ")   ; Capital letter G with acute
::'g::cp("ǵ")   ; Small letter g with acute
::``N::cp("Ǹ")  ; Capital letter N with grave
::``n::cp("ǹ")  ; Small letter n with grave
::cH::cp("Ȟ")   ; Capital letter H with caron
::ch::cp("ȟ")   ; Small letter h with caron
::,E::cp("Ȩ")   ; Capital letter E with cedilla
::,e::cp("ȩ")   ; Small letter e with cedilla
::_Y::cp("Ȳ")   ; Capital letter Y with macron
::_y::cp("ȳ")   ; Small letter y with macron
::ee::cp("ə")   ; Small letter schwa
::/i::cp("ɨ")   ; Small letter i with stroke
::,D::cp("Ḑ")   ; Capital letter D with cedilla
::,d::cp("ḑ")   ; Small letter d with cedilla
::_G::cp("Ḡ")   ; Capital letter G with macron
::_g::cp("ḡ")   ; Small letter g with macron
::"H::cp("Ḧ")   ; Capital letter H with diaeresis
::"h::cp("ḧ")   ; Small letter h with diaeresis
::,H::cp("Ḩ")   ; Capital letter H with cedilla
::,h::cp("ḩ")   ; Small letter h with cedilla
::'K::cp("Ḱ")   ; Capital letter K with acute
::'k::cp("ḱ")   ; Small letter k with acute
::'M::cp("Ḿ")   ; Capital letter M with acute
::'m::cp("ḿ")   ; Small letter m with acute
::'P::cp("Ṕ")   ; Capital letter P with acute
::'p::cp("ṕ")   ; Small letter p with acute
::~V::cp("Ṽ")   ; Capital letter V with tilde
::~v::cp("ṽ")   ; Small letter v with tilde
::``W::cp("Ẁ")  ; Capital letter W with grave
::``w::cp("ẁ")  ; Small letter w with grave
::'W::cp("Ẃ")   ; Capital letter W with acute
::'w::cp("ẃ")   ; Small letter w with acute
::"W::cp("Ẅ")   ; Capital letter W with diaeresis
::"w::cp("ẅ")   ; Small letter w with diaeresis
::"X::cp("Ẍ")   ; Capital letter X with diaeresis
::"x::cp("ẍ")   ; Small letter x with diaeresis
::^Z::cp("Ẑ")   ; Capital letter Z with circumflex
::^z::cp("ẑ")   ; Small letter z with circumflex
::"t::cp("ẗ")   ; Small letter t with diaeresis
::ow::cp("ẘ")   ; Small letter w with ring above
::oy::cp("ẙ")   ; Small letter y with ring above
::~E::cp("Ẽ")   ; Capital letter E with tilde
::~e::cp("ẽ")   ; Small letter e with tilde
::``Y::cp("Ỳ")  ; Capital letter Y with grave
::``y::cp("ỳ")  ; Small letter y with grave
::~Y::cp("Ỹ")   ; Capital letter Y with tilde
::~y::cp("ỹ")   ; Small letter y with tilde
:: .::cp(" ")   ; Punctuation space
::--::cp("–")   ; En dash
::-2::cp("–")   ; En dash
::2-::cp("–")   ; En dash
::-3::cp("—")   ; Em dash
::3-::cp("—")   ; Em dash
::<'::cp("‘")   ; Left single quotation mark
::'<::cp("‘")   ; Left single quotation mark
::>'::cp("’")   ; Right single quotation mark
::'>::cp("’")   ; Right single quotation mark
::,'::cp("‚")   ; Single low-9 quotation mark
::',::cp("‚")   ; Single low-9 quotation mark
::<"::cp("“")   ; Left double quotation mark
::"<::cp("“")   ; Left double quotation mark
::>"::cp("”")   ; Right double quotation mark
::">::cp("”")   ; Right double quotation mark
::,"::cp("„")   ; Double low-9 quotation mark
::",::cp("„")   ; Double low-9 quotation mark
::%o::cp("‰")   ; Per mille sign
::.<::cp("‹")   ; Single left-pointing angle quotation mark
::.>::cp("›")   ; Single right-pointing angle quotation mark
::^0::cp("⁰")   ; Superscript zero
::^4::cp("⁴")   ; Superscript four
::^5::cp("⁵")   ; Superscript five
::^6::cp("⁶")   ; Superscript six
::^7::cp("⁷")   ; Superscript seven
::^8::cp("⁸")   ; Superscript eight
::^9::cp("⁹")   ; Superscript nine
::^+::cp("⁺")   ; Superscript plus sign
::^=::cp("⁼")   ; Superscript equals sign
::^(::cp("⁽")   ; Superscript left parenthesis
::^)::cp("⁾")   ; Superscript right parenthesis
::^n::cp("ⁿ")   ; Superscript small letter n
::_0::cp("₀")   ; Subscript zero
::_1::cp("₁")   ; Subscript one
::_2::cp("₂")   ; Subscript two
::_3::cp("₃")   ; Subscript three
::_4::cp("₄")   ; Subscript four
::_5::cp("₅")   ; Subscript five
::_6::cp("₆")   ; Subscript six
::_7::cp("₇")   ; Subscript seven
::_8::cp("₈")   ; Subscript eight
::_9::cp("₉")   ; Subscript nine
::_+::cp("₊")   ; Subscript plus sign
::_=::cp("₌")   ; Subscript equals sign
::_(::cp("₍")   ; Subscript left parenthesis
::_)::cp("₎")   ; Subscript right parenthesis
::CE::cp("₠")   ; Euro-currency sign
::C/::cp("₡")   ; Colon sign
::/C::cp("₡")   ; Colon sign
::Cr::cp("₢")   ; Cruzeiro sign
::Fr::cp("₣")   ; French franc sign
::L=::cp("₤")   ; Lira sign
::=L::cp("₤")   ; Lira sign
::m/::cp("₥")   ; Mill sign
::/m::cp("₥")   ; Mill sign
::N=::cp("₦")   ; Naira sign
::=N::cp("₦")   ; Naira sign
::Pt::cp("₧")   ; Peseta sign
::Rs::cp("₨")   ; Rupee sign
::W=::cp("₩")   ; Won sign
::=W::cp("₩")   ; Won sign
::d-::cp("₫")   ; Dong sign
::C=::cp("€")   ; Euro sign
::=C::cp("€")   ; Euro sign
::c=::cp("€")   ; Euro sign
::=c::cp("€")   ; Euro sign
::E=::cp("€")   ; Euro sign
::=E::cp("€")   ; Euro sign
::sm::cp("℠")   ; Service mark
::SM::cp("℠")   ; Service mark
::tm::cp("™")   ; Trade mark sign
::TM::cp("™")   ; Trade mark sign
::"\::cp("〝")   ; Reversed double prime quotation mark
::"/::cp("〞")   ; Double prime quotation mark
::<-::cp("←")   ; Small arrow to left
::->::cp("→")   ; Small arrow to right
::<=::cp("⇐")   ; Double arrow to left
::=>::cp("⇒")   ; Double arrow to right
::<>::cp("⇔")   ; Two-way double arrow
::+>::cp("➨")   ; Fat arrow to right
::L_::cp("└")   ; Child of, hierachy link
::L>::cp("↳")   ; Child of arrow
::\/::cp("✔")   ; Fat tick/check mark
::**::cp("✻")   ; Teardrop-spoked asterisk
::.=::cp("•")   ; Bullet
::=_::cp("≡")   ; Identical to
::/=::cp("≠")   ; Not equal to
::!=::cp("≠")   ; Not equal to
::_<::cp("≤")   ; Less than or equal to
::_>::cp("≥")   ; Greater than or equal to
:::.::cp("∴")   ; Therefore
::3.::cp("…")   ; Ellipsis
::.3::cp("…")   ; Ellipsis
