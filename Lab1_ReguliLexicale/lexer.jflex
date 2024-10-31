package cup.example;
import java_cup.runtime.ComplexSymbolFactory;
import java_cup.runtime.ComplexSymbolFactory.Location;
import java_cup.runtime.Symbol;
import java.lang.*;
import java.io.InputStreamReader;

%%

%class Lexer
%implements sym
%public
%ignorecase
%unicode
%line
%column
%cup
%char
%{
	

    public Lexer(ComplexSymbolFactory sf, java.io.InputStream is){
		this(is);
        symbolFactory = sf;
    }
	public Lexer(ComplexSymbolFactory sf, java.io.Reader reader){
		this(reader);
        symbolFactory = sf;
    }
    
    private StringBuffer sb;
    private ComplexSymbolFactory symbolFactory;
    private int csline,cscolumn;

    public Symbol symbol(String name, int code){
		return symbolFactory.newSymbol(name, code,
						new Location(yyline+1,yycolumn+1, yychar), // -yylength()
						new Location(yyline+1,yycolumn+yylength(), yychar+yylength())
				);
    }
    public Symbol symbol(String name, int code, String lexem){
	return symbolFactory.newSymbol(name, code, 
						new Location(yyline+1, yycolumn +1, yychar), 
						new Location(yyline+1,yycolumn+yylength(), yychar+yylength()), lexem);
    }
    
    protected void emit_warning(String message){
    	System.out.println("scanner warning: " + message + " at : 2 "+ 
    			(yyline+1) + " " + (yycolumn+1) + " " + yychar);
    }
    
    protected void emit_error(String message){
    	System.out.println("scanner error: " + message + " at : 2" + 
    			(yyline+1) + " " + (yycolumn+1) + " " + yychar);
    }
%}

Newline    = \r | \n | \r\n
Whitespace = [ \t\f] | {Newline}
/* Number     = [0-9]+ */

digit 	   = [0-9]
alpha      = [a-zA-Z]
IVAL     = [0-9]+
RVAL = {digit}*.{digit}+
BVAL = "true" | "false" 


/* comments */
Comment = {TraditionalComment} | {EndOfLineComment}
TraditionalComment = "/*" {CommentContent} \*+ "/"
EndOfLineComment = "//" [^\r\n]* {Newline}
CommentContent = ( [^*] | \*+[^*/] )*

/* ident = ([:jletter:] | "_" ) ([:jletterdigit:] | [:jletter:] | "_" )* */

ID=[a-zA-Z0-9]*

%eofval{
    return symbolFactory.newSymbol("EOF",sym.EOF);
%eofval}

%state CODESEG

%%  

<YYINITIAL> {

  {Whitespace} {                              }
  ";"          { return symbolFactory.newSymbol("SEMI", SEMI); }
  "+"          { return symbolFactory.newSymbol("PLUS", PLUS); }
  "-"          { return symbolFactory.newSymbol("MINUS", MINUS); }
  "*"          { return symbolFactory.newSymbol("TIMES", TIMES); }
  "n"          { return symbolFactory.newSymbol("UMINUS", UMINUS); }
  "("          { return symbolFactory.newSymbol("LPAREN", LPAREN); }
  ")"          { return symbolFactory.newSymbol("RPAREN", RPAREN); }
  /* {Number}     { return symbolFactory.newSymbol("NUMBER", NUMBER, Integer.parseInt(yytext())); }*/
  
  ">"                                 {return symbolFactory.newSymbol("endTag",endTag);}
	   	  "<html"                     {return symbolFactory.newSymbol("htmlOpen",htmlOpen);}
	   	  "</html"                    {return symbolFactory.newSymbol("htmlClose",htmlClose);}
	   	  "<head"                     {return symbolFactory.newSymbol("headOpen",headOpen);}
	   	  "</head"                    {return symbolFactory.newSymbol("headClose",headClose);}
	   	  "<title"                    {return symbolFactory.newSymbol("titleOpen",titleOpen);}
	   	  "</title"                   {return symbolFactory.newSymbol("titleClose",titleClose);}
	   	  "<div"                      {return symbolFactory.newSymbol("divisionOpen",divisionOpen);}
	   	  "</div"                     {return symbolFactory.newSymbol("divisionClose",divisionClose);}
	      "<body"                     {return symbolFactory.newSymbol("bodyOpen",bodyOpen);}
          "</body"		              {return symbolFactory.newSymbol("bodyClose",bodyClose);}
          "<frame"		              {return symbolFactory.newSymbol("frameOpen",frameOpen);}
          "<frameset"		          {return symbolFactory.newSymbol("framesetOpen",framesetOpen);}
          "</frameset"		          {return symbolFactory.newSymbol("framesetClose",framesetClose);}
          "<noframes"		          {return symbolFactory.newSymbol("noframesOpen",noframesOpen);}
          "</noframes"		          {return symbolFactory.newSymbol("noframesClose",noframesClose);}
          "<form"	                  {return symbolFactory.newSymbol("formOpen",formOpen);}
	      "</form"		              {return symbolFactory.newSymbol("formClose",formClose);}
	      "<input"		    	      {return symbolFactory.newSymbol("input",input);}
          "<select"		     	      {return symbolFactory.newSymbol("selectOpen",selectOpen);}
          "</select"		          {return symbolFactory.newSymbol("selectClose",selectClose);}
          "<option"		              {return symbolFactory.newSymbol("optionOpen",optionOpen);}
          "</option"		          {return symbolFactory.newSymbol("optionClose",optionClose);}
          "<table"		              {return symbolFactory.newSymbol("tableOpen",tableOpen);}
          "</table"		              {return symbolFactory.newSymbol("tableClose",tableClose);}
          "<tr"			              {return symbolFactory.newSymbol("trOpen",trOpen);}
          "</tr"		              {return symbolFactory.newSymbol("trClose",trClose);}
          "<td"			              {return symbolFactory.newSymbol("tdOpen",tdOpen);}
          "</td"		              {return symbolFactory.newSymbol("tdClose",tdClose);}
          "<th"			              {return symbolFactory.newSymbol("thOpen",thOpen);}
	      "</th"		              {return symbolFactory.newSymbol("thClose",thClose);}
          "<thead"	                  {return symbolFactory.newSymbol("thead",thead);}
          "<tbody"		              {return symbolFactory.newSymbol("tbody",tbody);}
          "<img"	                  {return symbolFactory.newSymbol("img",img);}
          "<a"			              {return symbolFactory.newSymbol("aOpen",aOpen);}
          "</a"			              {return symbolFactory.newSymbol("aClose",aClose);}
          "<ul"			              {return symbolFactory.newSymbol("ulOpen",ulOpen);}
          "</ul"		              {return symbolFactory.newSymbol("ulClose",ulClose);}
          "<li"			              {return symbolFactory.newSymbol("liOpen",liOpen);}
          "</li"		              {return symbolFactory.newSymbol("liClose",liClose);}
          "<ol"			              {return symbolFactory.newSymbol("olOpen",olOpen);}
          "</ol"		              {return symbolFactory.newSymbol("olClose",olClose);}
          "<p"			              {return symbolFactory.newSymbol("pOpen",pOpen);}
          "</p>"		              {return symbolFactory.newSymbol("pClose",pClose);}
          "<i"			              {return symbolFactory.newSymbol("iOpen",iOpen);}
          "</i"			              {return symbolFactory.newSymbol("iClose",iClose);}
          "<u"			              {return symbolFactory.newSymbol("uOpen",uOpen);}
          "</u"			              {return symbolFactory.newSymbol("uClose",uClose);}
          "<b"			              {return symbolFactory.newSymbol("bOpen",bOpen);}
          "</b"			              {return symbolFactory.newSymbol("bClose",bClose);}
          "<small"		              {return symbolFactory.newSymbol("smallOpen",smallOpen);}
          "</small"		              {return symbolFactory.newSymbol("smallClose",smallClose);}
          "<sup"		              {return symbolFactory.newSymbol("supOpen",supOpen);}
          "</sup"		              {return symbolFactory.newSymbol("supClose",supClose);}
          "<sub"		              {return symbolFactory.newSymbol("subOpen",subOpen);}
          "</sub"		              {return symbolFactory.newSymbol("subClose",subClose);}
          "<center"		              {return symbolFactory.newSymbol("centerOpen",centerOpen);}
          "</center"		          {return symbolFactory.newSymbol("centerClose",centerClose);}
          "<font"		              {return symbolFactory.newSymbol("fontOpen",fontOpen);}
          "</font"		              {return symbolFactory.newSymbol("fontClose",fontClose);}
          "<h1"			              {return symbolFactory.newSymbol("h1Open",h1Open);}
          "</h1"		              {return symbolFactory.newSymbol("h1Close",h1Close);}
          "<h2"			              {return symbolFactory.newSymbol("h2Open",h2Open);}
          "</h2"		              {return symbolFactory.newSymbol("h2Close",h2Close);}
          "<h3"			              {return symbolFactory.newSymbol("h3Open",h3Open);}
          "</h3"		              {return symbolFactory.newSymbol("h3Close",h3Close);}
          "<h4"			              {return symbolFactory.newSymbol("h4Open",h4Open);}
          "</h4"		              {return symbolFactory.newSymbol("h4Close",h4Close);}
          "<h5"			              {return symbolFactory.newSymbol("h5Open",h5Open);}
          "</h5"		              {return symbolFactory.newSymbol("h5Close",h5Close);}
          "<h6"			              {return symbolFactory.newSymbol("h6Open",h6Open);}
          "</h6"		              {return symbolFactory.newSymbol("h6Close",h6Close);}
          "<hr"			              {return symbolFactory.newSymbol("hr",hr);}
          "<br"			              {return symbolFactory.newSymbol("br",br);}
          "<bgsound"                  {return symbolFactory.newSymbol("BGSOUND",BGSOUND);}
          "<base"                     {return symbolFactory.newSymbol("BASE",BASE);}
          "<isindex"                  {return symbolFactory.newSymbol("ISINDEX",ISINDEX);}
          "<link"                     {return symbolFactory.newSymbol("LINK",LINK);}
          "<meta"                     {return symbolFactory.newSymbol("META",META);}
          "<nextid"                   {return symbolFactory.newSymbol("NEXTID",NEXTID);}
          "<style"                    {return symbolFactory.newSymbol("styleOpen",styleOpen);}
          "</style"                   {return symbolFactory.newSymbol("styleClose",styleClose);} 
          "<plaintext"                {return symbolFactory.newSymbol("plainText",plainText);} 
          "<script"                   {return symbolFactory.newSymbol("scriptOpen",scriptOpen);}
          "</script"                  {return symbolFactory.newSymbol("scriptClose",scriptClose);}
          "<address"                  {return symbolFactory.newSymbol("addressOpen",addressOpen);}
          "</address"                 {return symbolFactory.newSymbol("addressClose",addressClose);}
          "<embed"                    {return symbolFactory.newSymbol("EMBED",EMBED);}
          "<iframe"                   {return symbolFactory.newSymbol("IFRAME",IFRAME);}
          "<img"                      {return symbolFactory.newSymbol("IMG",IMG);}
          "</spacer"                  {return symbolFactory.newSymbol("SPACER",SPACER);}
          "<wbr"                      {return symbolFactory.newSymbol("WBR",WBR);}
          "<applet"                   {return symbolFactory.newSymbol("appletOpen",appletOpen);}
          "</applet"                  {return symbolFactory.newSymbol("appletClose",appletClose);}
          "<param"                    {return symbolFactory.newSymbol("PARAM",PARAM);}
          "<abbr"                     {return symbolFactory.newSymbol("abbrOpen",abbrOpen);}
          "</abbr"                    {return symbolFactory.newSymbol("abbrClose",abbrClose);}
          "<acronym"                  {return symbolFactory.newSymbol("acronymOpen",acronymOpen);}  
          "</acronym"                 {return symbolFactory.newSymbol("acronymClose",acronymClose);}  
          "<cite"                     {return symbolFactory.newSymbol("citeOpen",citeOpen);} 
          "</cite"                    {return symbolFactory.newSymbol("citeClose",citeClose);} 
          "<code"                     {return symbolFactory.newSymbol("codeOpen",codeOpen);} 
          "</code"            		  {return symbolFactory.newSymbol("codeClose",codeClose);} 
          "<dfn"              		  {return symbolFactory.newSymbol("dfnOpen",dfnOpen);} 
          "/dfn"              		  {return symbolFactory.newSymbol("dfnClose",dfnClose);}
          "<em"               		  {return symbolFactory.newSymbol("emOpen",emOpen);} 
          "/em"               		  {return symbolFactory.newSymbol("emClose",emClose);}
          "<kbd"              		  {return symbolFactory.newSymbol("kbdOpen",kbdOpen);}  
          "</kbd"             		  {return symbolFactory.newSymbol("kbdClose",kbdClose);}
          "<q"                		  {return symbolFactory.newSymbol("qOpen",qOpen);}  
          "</q"               		  {return symbolFactory.newSymbol("qClose",qClose);}
          "<strong"          		  {return symbolFactory.newSymbol("strongOpen",strongOpen);}
          "</strong"              	  {return symbolFactory.newSymbol("strongClose",strongClose);}
          "<var"              		  {return symbolFactory.newSymbol("varOpen",varOpen);}
          "</var"            		  {return symbolFactory.newSymbol("varClose",varClose);}
          "<ilayer"           		  {return symbolFactory.newSymbol("ilayerOpen",ilayerOpen);}
          "</ilayer"          		  {return symbolFactory.newSymbol("ilayerClose",ilayerClose);}
          "<noembed"          		  {return symbolFactory.newSymbol("noembedOpen",noembedOpen);}
          "</noembed"         		  {return symbolFactory.newSymbol("noembedClose",noembedClose);}
          "<noscript"         		  {return symbolFactory.newSymbol("noscriptOpen",noscriptOpen);}
          "</noscript"        		  {return symbolFactory.newSymbol("noscriptClose",noscriptClose);}
          "<object"           		  {return symbolFactory.newSymbol("objectOpen",objectOpen);}    
          "</object"          		  {return symbolFactory.newSymbol("objectClose",objectClose);}
          "<bdo"              		  {return symbolFactory.newSymbol("bdoOpen",bdoOpen);}
          "</bdo"             		  {return symbolFactory.newSymbol("bdoClose",bdoClose);}
          "<big"              		  {return symbolFactory.newSymbol("bigOpen",bigOpen);}
          "</big"             		  {return symbolFactory.newSymbol("bigClose",bigClose);}
          "<blink"            		  {return symbolFactory.newSymbol("blinkOpen",blinkOpen);}
          "</blink"           	      {return symbolFactory.newSymbol("blinkClose",blinkClose);}
          "<s"               		  {return symbolFactory.newSymbol("sOpen",sOpen);}
          "</s"               		  {return symbolFactory.newSymbol("sClose",sClose);}
          "<span"             	   	  {return symbolFactory.newSymbol("spanOpen",spanOpen);}
          "</span"            		  {return symbolFactory.newSymbol("spanClose",spanClose);}
          "<strike"           		  {return symbolFactory.newSymbol("strikeOpen",strikeOpen);}
          "</strike"          		  {return symbolFactory.newSymbol("strikeClose",strikeClose);}
          "<tt"               		  {return symbolFactory.newSymbol("ttOpen",ttOpen);}
          "</tt"              		  {return symbolFactory.newSymbol("ttClose",ttClose);}
          "<marquee"           		  {return symbolFactory.newSymbol("marqueeOpen",marqueeOpen);}
          "</marquee"         		  {return symbolFactory.newSymbol("marqueeClose",marqueeClose);}
          "<basefont"        		  {return symbolFactory.newSymbol("basefontOpen",basefontOpen);}
          "</basefont"        		  {return symbolFactory.newSymbol("basefontClose",basefontClose);}
          "<blockquote"      		  {return symbolFactory.newSymbol("blockquoteOpen",blockquoteOpen);}
          "</blockquote"     		  {return symbolFactory.newSymbol("blockquoteClose",blockquoteClose);}
          "<dir"             		  {return symbolFactory.newSymbol("dirOpen",dirOpen);}
          "</dir"            		  {return symbolFactory.newSymbol("dirClose",dirClose);} 
          "<dl"              		  {return symbolFactory.newSymbol("dlOpen",dlOpen);} 
          "</dl"             		  {return symbolFactory.newSymbol("dlClose",dlClose);} 
          "<dt"             		  {return symbolFactory.newSymbol("dtOpen",dtOpen);} 
          "</dt"             		  {return symbolFactory.newSymbol("dtClose",dtClose);} 
          "<dd"              		  {return symbolFactory.newSymbol("ddOpen",ddOpen);} 
          "</dd"              		  {return symbolFactory.newSymbol("ddClose",ddClose);}
          "<keygen"        		      {return symbolFactory.newSymbol("KEYGEN",KEYGEN);}
          "<fieldset"       		  {return symbolFactory.newSymbol("fieldsetOpen",fieldsetOpen);}
          "</fieldset"      		  {return symbolFactory.newSymbol("fieldsetClose",fieldsetClose);}
          "<legend"         		  {return symbolFactory.newSymbol("legendOpen",legendOpen);}
          "</legend"        		  {return symbolFactory.newSymbol("legendClose",legendClose);} 
          "<label"          		  {return symbolFactory.newSymbol("LABEL",LABEL);}
          "<textarea"         		  {return symbolFactory.newSymbol("textareaOpen",textareaOpen);}
          "</textarea"       		  {return symbolFactory.newSymbol("textareaClose",textareaClose);}  
          "<optgroup"         		  {return symbolFactory.newSymbol("optgroupOpen",optgroupOpen);} 
          "</optgroup"        		  {return symbolFactory.newSymbol("optgroupClose",optgroupClose);} 
          "<listing"         		  {return symbolFactory.newSymbol("listingOpen",listingOpen);}  
          "</listing"         		  {return symbolFactory.newSymbol("listingClose",listingClose);}   
          "<menu"             		  {return symbolFactory.newSymbol("menuOpen",menuOpen);} 
          "</menu"            		  {return symbolFactory.newSymbol("menuClose",menuClose);}   
          "<multicol"        		  {return symbolFactory.newSymbol("multicolOpen",multicolOpen);}   
          "</multicol"        		  {return symbolFactory.newSymbol("multicolClose",multicolClose);}   
          "<nobr"             		  {return symbolFactory.newSymbol("nobrOpen",nobrOpen);}
          "</nobr"           		  {return symbolFactory.newSymbol("nobrClose",nobrClose);}
          "<pre"              		  {return symbolFactory.newSymbol("preOpen",preOpen);}
          "</pre"             		  {return symbolFactory.newSymbol("preClose",preClose);}
          "<caption"         		  {return symbolFactory.newSymbol("captionOpen",captionOpen);}
          "</caption"        		  {return symbolFactory.newSymbol("captionClose",captionClose);}
          "<colgroup"        		  {return symbolFactory.newSymbol("COLGROUP",COLGROUP);}
          "<col"              		  {return symbolFactory.newSymbol("COL",COL);}
          "<tfoot"           		  {return symbolFactory.newSymbol("tfoot",tfoot);}
          "<xmp"             		  {return symbolFactory.newSymbol("xmpOpen",xmpOpen);}
          "</xmp"            		  {return symbolFactory.newSymbol("xmpClose",xmpClose);}
          "<del"              		  {return symbolFactory.newSymbol("delOpen",delOpen);}
          "</del"             		  {return symbolFactory.newSymbol("delClose",delClose);}
          "<ins"              		  {return symbolFactory.newSymbol("insOpen",insOpen);}
          "</ins"            		  {return symbolFactory.newSymbol("insClose",insClose);}
          "<layer"            		  {return symbolFactory.newSymbol("layerOpen",layerOpen);}
          "</layer"           		  {return symbolFactory.newSymbol("layerClose",layerClose);}
          "<map"               		  {return symbolFactory.newSymbol("mapOpen",mapOpen);}
          "</map"            		  {return symbolFactory.newSymbol("mapClose",mapClose);}
          "<area"            	   	  {return symbolFactory.newSymbol("AREA",AREA);}
           
           
		  ":" 	 		          {return symbolFactory.newSymbol("colon",colon); }
		  ";"    		          {return symbolFactory.newSymbol("semicolon",semicolon); }
		  ","    		          {return symbolFactory.newSymbol("comma",comma); }
		  ":="   		          {return symbolFactory.newSymbol("assign",assign); }
          
          {Comment} 	          {return symbolFactory.newSymbol("comment", comment);}	 
	 	  {ID}	                  {return symbolFactory.newSymbol("plainText", plainText);}
	  	  {IVAL}                  {return symbolFactory.newSymbol("IVAL", IVAL, Integer.parseInt(yytext()));}
	   	  {RVAL}                  {return symbolFactory.newSymbol("IVAL", IVAL, Float.parseFloat(yytext()));} 
  
  
}



// error fallback
.|\n          { emit_warning("Unrecognized character '" +yytext()+"' -- ignored"); }
