//
// This file was generated by the JavaTM Architecture for XML Binding(JAXB) Reference Implementation, vJAXB 2.1.10 in JDK 6 
// See <a href="http://java.sun.com/xml/jaxb">http://java.sun.com/xml/jaxb</a> 
// Any modifications to this file will be lost upon recompilation of the source schema. 
// Generated on: 2011.12.06 at 08:06:49 PM EST 
//


package backend;

import javax.xml.bind.JAXBElement;
import javax.xml.bind.annotation.XmlElementDecl;
import javax.xml.bind.annotation.XmlRegistry;
import javax.xml.namespace.QName;


/**
 * This object contains factory methods for each 
 * Java content interface and Java element interface 
 * generated in the backend package. 
 * <p>An ObjectFactory allows you to programatically 
 * construct new instances of the Java representation 
 * for XML content. The Java representation of XML 
 * content can consist of schema derived interfaces 
 * and classes representing the binding of schema 
 * type definitions, element declarations and model 
 * groups.  Factory methods for each of these are 
 * provided in this class.
 * 
 */
@XmlRegistry
public class ObjectFactory {

    private final static QName _TypeQuestionLeftHeader_QNAME = new QName("", "leftHeader");
    private final static QName _TypeQuestionText_QNAME = new QName("", "text");
    private final static QName _TypeQuestionCheck_QNAME = new QName("", "check");
    private final static QName _TypeQuestionRightHeader_QNAME = new QName("", "rightHeader");
    private final static QName _TypeQuestionRadio_QNAME = new QName("", "radio");
    private final static QName _TypeQuestionCaption_QNAME = new QName("", "caption");
    private final static QName _TypeQuestionShortName_QNAME = new QName("", "shortName");

    /**
     * Create a new ObjectFactory that can be used to create new instances of schema derived classes for package: backend
     * 
     */
    public ObjectFactory() {
    }

    /**
     * Create an instance of {@link Choicetype }
     * 
     */
    public Choicetype createChoicetype() {
        return new Choicetype();
    }

    /**
     * Create an instance of {@link TypeRadio }
     * 
     */
    public TypeRadio createTypeRadio() {
        return new TypeRadio();
    }

    /**
     * Create an instance of {@link TypeQuestion }
     * 
     */
    public TypeQuestion createTypeQuestion() {
        return new TypeQuestion();
    }

    /**
     * Create an instance of {@link Survey }
     * 
     */
    public Survey createSurvey() {
        return new Survey();
    }

    /**
     * Create an instance of {@link TypeText }
     * 
     */
    public TypeText createTypeText() {
        return new TypeText();
    }

    /**
     * Create an instance of {@link TypeCheck }
     * 
     */
    public TypeCheck createTypeCheck() {
        return new TypeCheck();
    }

    /**
     * Create an instance of {@link JAXBElement }{@code <}{@link String }{@code >}}
     * 
     */
    @XmlElementDecl(namespace = "", name = "leftHeader", scope = TypeQuestion.class)
    public JAXBElement<String> createTypeQuestionLeftHeader(String value) {
        return new JAXBElement<String>(_TypeQuestionLeftHeader_QNAME, String.class, TypeQuestion.class, value);
    }

    /**
     * Create an instance of {@link JAXBElement }{@code <}{@link TypeText }{@code >}}
     * 
     */
    @XmlElementDecl(namespace = "", name = "text", scope = TypeQuestion.class)
    public JAXBElement<TypeText> createTypeQuestionText(TypeText value) {
        return new JAXBElement<TypeText>(_TypeQuestionText_QNAME, TypeText.class, TypeQuestion.class, value);
    }

    /**
     * Create an instance of {@link JAXBElement }{@code <}{@link TypeCheck }{@code >}}
     * 
     */
    @XmlElementDecl(namespace = "", name = "check", scope = TypeQuestion.class)
    public JAXBElement<TypeCheck> createTypeQuestionCheck(TypeCheck value) {
        return new JAXBElement<TypeCheck>(_TypeQuestionCheck_QNAME, TypeCheck.class, TypeQuestion.class, value);
    }

    /**
     * Create an instance of {@link JAXBElement }{@code <}{@link String }{@code >}}
     * 
     */
    @XmlElementDecl(namespace = "", name = "rightHeader", scope = TypeQuestion.class)
    public JAXBElement<String> createTypeQuestionRightHeader(String value) {
        return new JAXBElement<String>(_TypeQuestionRightHeader_QNAME, String.class, TypeQuestion.class, value);
    }

    /**
     * Create an instance of {@link JAXBElement }{@code <}{@link TypeRadio }{@code >}}
     * 
     */
    @XmlElementDecl(namespace = "", name = "radio", scope = TypeQuestion.class)
    public JAXBElement<TypeRadio> createTypeQuestionRadio(TypeRadio value) {
        return new JAXBElement<TypeRadio>(_TypeQuestionRadio_QNAME, TypeRadio.class, TypeQuestion.class, value);
    }

    /**
     * Create an instance of {@link JAXBElement }{@code <}{@link String }{@code >}}
     * 
     */
    @XmlElementDecl(namespace = "", name = "caption", scope = TypeQuestion.class)
    public JAXBElement<String> createTypeQuestionCaption(String value) {
        return new JAXBElement<String>(_TypeQuestionCaption_QNAME, String.class, TypeQuestion.class, value);
    }

    /**
     * Create an instance of {@link JAXBElement }{@code <}{@link String }{@code >}}
     * 
     */
    @XmlElementDecl(namespace = "", name = "shortName", scope = TypeQuestion.class)
    public JAXBElement<String> createTypeQuestionShortName(String value) {
        return new JAXBElement<String>(_TypeQuestionShortName_QNAME, String.class, TypeQuestion.class, value);
    }

}
