import java.io.FileNotFoundException;
import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;

public class main {

	/**
	 * @param args
	 * @throws UnsupportedEncodingException 
	 * @throws FileNotFoundException 
	 */
	public static void main(String[] args) throws FileNotFoundException, UnsupportedEncodingException {
		// TODO Auto-generated method stub

		PrintWriter writer = new PrintWriter("name2txt.txt", "UTF-8");
		writer.println("The first line");
		writer.println("The second line");
		writer.close();
		System.out.print("Esto es una prueba");
		
		
	}

}
