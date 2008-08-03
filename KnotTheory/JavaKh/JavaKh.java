import java.io.BufferedReader;
import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStreamReader;
import java.io.PrintStream;

import org.apache.commons.cli.CommandLine;
import org.apache.commons.cli.CommandLineParser;
import org.apache.commons.cli.HelpFormatter;
import org.apache.commons.cli.Options;
import org.apache.commons.cli.PosixParser;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.log4j.Level;
import org.apache.log4j.Logger;

public class JavaKh {
	private static final Log log = LogFactory.getLog(JavaKh.class);
	
    public static boolean using_h = false;
    
    public static void main(String args[]) throws java.io.IOException {
    	
    	boolean reorderCrossings = true;
    	
    /* Process command-line arguments */
    	
		try {
			CommandLineParser parser = new PosixParser();

			Options options = new Options();
			options.addOption("h", "help", false, "show this help screen");
			options.addOption("i", "info", false,
					"turn on lower level debugging statements [INFO].");
			options.addOption("d", "debug", false,
					"turn on lowest level debugging statements [DEBUG].");
			options.addOption("U", "universal", false, "use the universal theory over the integers");
			options.addOption("Z", "integer", false, "work over the integers");
			options.addOption("Q", "rational", false, "work over the rationals");
			options.addOption("m", "mod", true, "work over a field of characteristic p");
			options.addOption("O" , "ordered", false, "don't change the ordering of the crossings");
			
			CommandLine line = parser.parse(options, args);
			String[] clean_args = line.getArgs();

			Logger rootLogger = Logger.getRootLogger();
			if (line.hasOption("d"))
				rootLogger.setLevel(Level.DEBUG);
			else if (line.hasOption("i"))
				rootLogger.setLevel(Level.INFO);
			else
				rootLogger.setLevel(Level.WARN);

			if(line.hasOption("Z")) {
				BaseRing.setRing("Int");
			} else if(line.hasOption("Q")) {
				BaseRing.setRing("Rational");
			} else if(line.hasOption("U")) {
				using_h = true;
				BaseRing.setRing("Int");				
			} else if(line.hasOption("m")) {
				int p = Integer.parseInt(line.getOptionValue("m"));
				if (p == 0)
				    BaseRing.setRing("Rational");
				else {
				    BaseRing.setRing("ModP");
				    ModP.setP(p);
				}
			} else {
				// default
				BaseRing.setRing("Rational");
			}
			
			if(line.hasOption("O")) reorderCrossings = false;
			
			if (line.hasOption("h")) {
				HelpFormatter formatter = new HelpFormatter();
				formatter.printHelp(
						"Usage: java JavaKh [OPTIONS]", options);
				System.exit(1);
			}

		} catch (Exception e) {
			log.fatal("Error found initializing", e);
			System.exit(1);
		}

	//Komplex.checkReidemeister();
	BufferedReader br=new BufferedReader(new InputStreamReader(System.in));
	while (true) {
	    int knot[][] = Komplex.getPD(br);
	    if (knot == null)
		break;
	    Komplex k = Komplex.generateFast(knot, Komplex.getSigns(knot), reorderCrossings);
	    assert k.check(true);
	    System.out.println("\"" + k.Kh() + "\"");
	    //k.debugPrint();
	}
	br.close();
    }

}
