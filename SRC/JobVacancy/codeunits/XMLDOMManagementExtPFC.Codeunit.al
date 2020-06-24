codeunit 50106 XMLDOMManagementExt_PFC
{

    trigger OnRun()
    begin
    end;

   procedure XMLEscape(Text: Text): Text
    var
        XmlNode: XmlNode;
    begin
        XmlNode := XmlElement.Create('XMLEscape', '', Text).AsXmlNode();
        exit(XmlNode.AsXmlElement().InnerXml());
    end;
}
