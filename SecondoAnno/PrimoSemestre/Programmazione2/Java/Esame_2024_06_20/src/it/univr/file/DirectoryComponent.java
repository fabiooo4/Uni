package it.univr.file;

import java.io.FileNotFoundException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.stream.Stream;

public class DirectoryComponent extends AbstractComponent {
	// aggiungete campi, se servissero
	private Component[] children;

	/**
	 * Costruisce una componente di tipo directory con il nome indicato e le
	 * sottocomponenti (figli) indicate.
	 */
	public DirectoryComponent(String name, Component... children) {
		super(name);
		this.children = children;

		Arrays.sort(this.children, (c1, c2) -> c1.getName().compareTo(c2.getName()));
	}

	// implementate sotto i metodi public ancora astratti
	@Override
	public String toString(String nesting) {
		String tree = nesting + getName() + "/";

		for (Component child : children) {
			tree += "\n" + child.toString(nesting + "  ");
		}

		return tree;
	}

	@Override
	public int size() {
		return 100 + Stream.of(children).mapToInt(c -> c.size()).sum();
	}

	@Override
	public List<FileComponent> getFiles() {
		List<FileComponent> files = new ArrayList<FileComponent>();
		Stream.of(children).map(c -> c.getFiles()).forEach(files::addAll);
		return files;
	}

	@Override
	public String find(String name) throws FileNotFoundException {
		for (Component child : children) {
			try {
				return getName() + "/" + child.find(name);
			} catch (FileNotFoundException e) {
				continue;
			}
		}

		throw new FileNotFoundException();
	}

}