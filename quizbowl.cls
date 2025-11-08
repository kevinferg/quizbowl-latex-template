% quizbowl.cls

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%    Package for quizbowl tossup+bonus questions    %%%%
%%%%---------------------------------------------------%%%%
%%%%    Usage:
%%%%---------------------------------------------------%%%%
    % \documentclass{quizbowl}
    
    % \tournament{Tournament name}
    % \round{Game 1}
    % \description{Brief instructional paragraph}
    
    
    % \begin{document}
    % \maketitle
    
    
    % \begin{tossup}
    %     \category{Category}
    %     \question{Text is bold prior ["PRY-uhr"] to a paren-star-paren (*) if it is present.}
    %     \answer{Text between sets of *asterisks* is bold and underlined. \\(Text between "~tildes~" is just underlined.)}
    % \end{tossup}
    
    % \begin{bonus}
    %     \category{Category}
    %     \intro{Optional intro text}
    %     \question{Part A}
    %     \answer{*A*nswer *A*}
    %     \question{Part B}
    %     \answer{Answer *B*}
    %     \question{Part C}
    %     \answer{*Answer* C}
    % \end{bonus}
    
    % \end{document}
%%%%---------------------------------------------------%%%%

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{quizbowl}[Quizbowl Packet]

\RequirePackage{xparse}
\RequirePackage{xstring}
\RequirePackage{ulem}
\RequirePackage{tcolorbox}
\RequirePackage{chngcntr}


%%%%==================================%%%%
%%%%    General document formatting   %%%%
%%%%----------------------------------%%%%
\LoadClass[12pt]{article}
\RequirePackage[margin=.7in]{geometry}

% \usepackage{fontspec}
% \setmainfont{Times New Roman}

\setlength{\parindent}{0pt}
\setlength{\parskip}{0.5\baselineskip}
\setlength{\headheight}{14.5pt}

\RequirePackage[english]{babel}
\RequirePackage[autostyle, english = american]{csquotes}
\MakeOuterQuote{"}
%%%%==================================%%%%





%%%%=====================================================%%%%
%%%%            Title info and formatting                %%%%
%%%%=====================================================%%%%
\newcommand{\tournament}[1]{\def\tournamentname{#1}}
\newcommand{\round}[1]{\def\roundnumber{#1}}
\renewcommand{\description}[1]{\def\rounddescription{#1}}
%%%%-----------------------------------------------------%%%%
\renewcommand{\maketitle}{%
  \thispagestyle{frontpage}
  \begin{center}
    {\LARGE\bfseries
      \ifdefined\tournamentname \tournamentname \par\fi
    }
    {\large
      \ifdefined\roundnumber \roundnumber \par\fi
    }
    \ifdefined\rounddescription \rounddescription \fi
  \end{center}
}
%%%%-----------------------------------------------------%%%%
\usepackage{fancyhdr}
\pagestyle{fancy}
\fancyhf{}

% Header
\fancyhead[L]{\ifdefined\tournamentname \hspace{2mm} \tournamentname \fi}
\fancyhead[R]{\ifdefined\roundnumber Round: \roundnumber \hspace{2mm} \fi}
\renewcommand{\headrulewidth}{0pt}

% Footer
\fancyfoot[C]{\thepage}
\renewcommand{\footrulewidth}{0pt}

\fancypagestyle{frontpage}{
  \fancyhf{}
  \fancyfoot[C]{\thepage}
  \renewcommand{\headrulewidth}{0pt}
  \renewcommand{\footrulewidth}{0pt}
}
%%%%=====================================================%%%%




%%%%==============================================================%%%%
%%%%  Format tossup: bold until (*), [text] -> \pronounce{text}  %%%%
%%%%--------------------------------------------------------------%%%%
\usepackage{xparse,xstring}
\makeatletter
\NewDocumentCommand{\formatTU}{m}{%
  \def\qb@tmp{#1}%
  \@tossupreplace\qb@tmp%
  \IfSubStr{\qb@tmp}{(*)}{%
    \StrBefore{\qb@tmp}{(*)}[\qb@before]%
    \StrBehind{\qb@tmp}{(*)}[\qb@after]%
    \noindent\textbf{\qb@before(*)}\qb@after\par
  }{%
    \noindent\qb@tmp\par
  }%
}

\newcommand{\@tossupreplace}[1]{%
  \IfSubStr{#1}{[}{%
    \StrBefore{#1}{[}[\qb@left]%
    \StrBehind{#1}{[}[\qb@rightA]%
    \StrBefore{\qb@rightA}{]}[\qb@inside]%
    \StrBehind{\qb@rightA}{]}[\qb@rightB]%
    \edef\qb@tmp{\qb@left\noexpand\pronounce{\qb@inside}\qb@rightB}%
    \@tossupreplace{\qb@tmp}%
  }{}%
}
\makeatother
%%%%==============================================================%%%%




%%%%==========================================%%%%
%%%%     Phonetic spelling with \pronounce    %%%%
%%%%------------------------------------------%%%%
\RequirePackage{xcolor}
\definecolor{faintgray}{gray}{0.9}
\NewDocumentCommand{\pronounce}{m}{%
  {\begingroup
    \setlength{\fboxsep}{1pt}%
    \colorbox{faintgray}{\texttt{\footnotesize [#1]}}%
  \endgroup}%
}
%%%%==========================================%%%%


%%%%==============================================================%%%%
%%%%     Format answers: *bold+underline*, ~underline only~       %%%%
%%%%--------------------------------------------------------------%%%%
\makeatletter
\newcommand{\formatANS}[1]{\@ansparse#1*\stopmarker}%

\def\@ansparse#1*#2\stopmarker{%
  \@tildeparse#1~\stopmarker%
  \if\relax\detokenize{#2}\relax\else%
    \@@ansparse#2\stopmarker%
  \fi%
}%

\def\@@ansparse#1*#2\stopmarker{%
  \if\relax\detokenize{#2}\relax%
    *#1%
  \else%
    \textbf{\underline{#1}}%
    \@ansparse#2\stopmarker%
  \fi%
}%

\def\@tildeparse#1~#2\stopmarker{%
  #1%
  \if\relax\detokenize{#2}\relax\else%
    \@@tildeparse#2\stopmarker%
  \fi%
}%

\def\@@tildeparse#1~#2\stopmarker{%
  \if\relax\detokenize{#2}\relax%
    ~#1%
  \else%
    \underline{#1}%
    \@tildeparse#2\stopmarker%
  \fi%
}%
\makeatother
%%%%==============================================================%%%%


%%%%===============================%%%%
%%%%    Dotted and solid lines    %%%%
%%%%===============================%%%%
\newcommand{\solidline}[0]{
  \par\kern3pt
  \hrule height 1pt
  \kern3pt\par\vspace{3pt}
}
\newcommand{\dottedline}[0]{
  \vspace{-1em}\par\kern3pt%
  \noindent\makebox[\linewidth]%
  {\dotfill}\par%
}
%%%%===============================%%%%




%%%%==============================================================%%%%
%%%%                     Tossup environment                       %%%%
%%%%--------------------------------------------------------------%%%%
\RequirePackage{ragged2e}

\newcounter{tossupcounter}
\newif\ifintossup

\newenvironment{tossup}{%
  \stepcounter{tossupcounter}%
  \begin{tcolorbox}[
    colframe=white, colback=white, boxrule=0.5pt, arc=3mm,
    left=2mm, right=2mm, top=2mm, bottom=0mm, sharp corners=south
  ]
  \setlength{\topsep}{0pt}%
  \setlength{\parskip}{0pt}%
  \setlength{\partopsep}{0pt}%
  \setlength{\leftskip}{0pt}%
  \setlength{\rightskip}{0pt}%
  \intossuptrue%
  \begingroup
  \catcode`\&=11
  \catcode`\$=11
  \catcode`\%=11
  \catcode`\#=11
  \catcode`\<=11
  \catcode`\>=11
  \catcode`\_=11
}{%
  \endgroup
  \intossupfalse%
  \end{tcolorbox}%
}

\newcommand{\TUcategory}[1]{%
  {\RaggedRight\bfseries TOSSUP \thetossupcounter. #1\par}%
  \solidline
}


\newcommand{\TUquestion}[1]{%
  \formatTU{#1}
}

\newcommand{\TUanswer}[1]{%
\vspace{2pt}%
\begin{flushright}%
\formatANS{ANSWER:\;\;#1}%
\end{flushright}%
\par%
\vspace{2pt}%
}
%%%%==============================================================%%%%






%%%%==================================================================%%%%
%%%%                         Bonus environment                        %%%%
%%%%==================================================================%%%%
\RequirePackage{ragged2e}
\RequirePackage{chngcntr}
\newcounter{bonuscounter}
\newcounter{partcounter}
\counterwithin{partcounter}{bonuscounter}

\newif\ifinbonus

\newenvironment{bonus}{%
  \stepcounter{bonuscounter}%
  \begin{tcolorbox}[colframe=white, colback=white, boxrule=0.5pt, arc=3mm,
    left=2mm, right=2mm, top=1mm, bottom=1mm, sharp corners=north]
  \setlength{\topsep}{0pt}%
  \setlength{\parskip}{0pt}%
  \setlength{\partopsep}{0pt}%
  \setlength{\leftskip}{0pt}%
  \setlength{\rightskip}{0pt}%
  \normalfont
  \RaggedRight
  \inbonustrue
  \begingroup
  \catcode`\&=11
  \catcode`\$=11
  \catcode`\%=11
  \catcode`\#=11
  \catcode`\<=11
  \catcode`\>=11
  \catcode`\_=11
}{%
  \endgroup
  \inbonusfalse
  \end{tcolorbox}%
}

\newcommand{\BOcategory}[1]{%
  {\RaggedRight\bfseries BONUS \thebonuscounter. #1\par}%
  \solidline
}

\newcommand{\BOquestion}[1]{%
  \stepcounter{partcounter}%
  \dottedline
  \justify{\textbf{\Alph{partcounter}.}\;\;\formatTU{#1}}%
}

\newcommand{\BOanswer}[1]{%
\vspace{2pt}%
\begin{flushright}%
\formatANS{ANSWER:\;\;#1}%
\end{flushright}%
\par%
\vspace{2pt}%
}
%%%%==================================================================%%%%




\newcommand{\category}[1]{%
\ifintossup%
    \TUcategory{#1}%
\else%
    \BOcategory{#1}%
\fi%
}


\newcommand{\question}[1]{%
\ifintossup%
    \TUquestion{#1}%
\else%
    \BOquestion{#1}%
\fi%
}

\newcommand{\answer}[1]{%
\ifintossup%
    \TUanswer{#1}%
\else%
    \BOanswer{#1}%
\fi%
}

\newcommand{\intro}[1]{%
\justify{#1}% (Intro text for a bonus question)
\vspace{3pt}%
}