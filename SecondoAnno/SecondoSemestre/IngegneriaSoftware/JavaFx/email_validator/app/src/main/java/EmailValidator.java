import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javafx.application.Application;
import javafx.geometry.Insets;
import javafx.scene.Scene;
import javafx.scene.control.Button;
import javafx.scene.control.Label;
import javafx.scene.control.TextField;
import javafx.scene.layout.VBox;
import javafx.scene.text.Font;
import javafx.stage.Stage;

public class EmailValidator extends Application {

  @Override
  public void start(Stage primaryStage) {
    // Create UI elements
    TextField emailField = new TextField();
    emailField.setPromptText(" Enter your email address ");
    emailField.setFont(Font.font(20));

    Button submitButton = new Button(" Validate ");
    submitButton.setFont(Font.font(20));

    Label resultLabel = new Label("");
    resultLabel.setFont(Font.font(20));

    // Set up event handler for the button
    submitButton.setOnAction(event -> {
      if (validateEmail(emailField.getText())) {
        String text = "Email valid";
        System.out.println(text);
        resultLabel.setText(text);

      } else {
        String text = "Email not valid";
        System.out.println(text);
        resultLabel.setText(text);
      }

    });

    // Create and configure the layout
    VBox root = new VBox(10);
    Label fieldLabel = new Label(" Email Validator ");
    fieldLabel.setFont(Font.font(20));
    root.getChildren().addAll(
        fieldLabel,
        emailField,
        submitButton,
        resultLabel);

    // Create and show the scene
    Scene scene = new Scene(root, 500, 200);
    primaryStage.setTitle(" Email Validator ");
    primaryStage.setScene(scene);
    primaryStage.show();
  }

  public boolean validateEmail(String email) {
    Pattern pattern = Pattern.compile("^[a-zA-Z0-9. %+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$");
    Matcher matcher = pattern.matcher(email);

    if (matcher.matches())
      return true;
    else
      return false;
  }

  public static void main(String[] args) {
    launch(args);
  }
}
