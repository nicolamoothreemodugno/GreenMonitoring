<%@ page import="it.unisa.greenmonitoring.businesslogic.gestionecoltivazione.TerrenoManager" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Random" %>
<%@ page import="java.lang.reflect.AnnotatedArrayType" %>
<%@ page import="it.unisa.greenmonitoring.dataccess.beans.*" %>
<%@ page import="it.unisa.greenmonitoring.businesslogic.gestionemonitoraggio.ColtivazioneManager" %>
<%@ page import="it.unisa.greenmonitoring.businesslogic.gestionesensore.SensoreManager" %>
<%@ page import="it.unisa.greenmonitoring.businesslogic.gestionecoltivazione.PiantaManager" %>
<%@ page import="java.sql.Date" %><%--
  Created by IntelliJ IDEA.
  User: Nicola
  Date: 16/01/2023
  Time: 16:40
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>

  <!-- Import Bootstrap -->
  <link href="bootstrap-5.2.3-dist/css/bootstrap.min.css" rel="styleshee  t">
  <script src="bootstrap-5.2.3-dist/js/bootstrap.bundle.min.js"></script>
  <style>
    #formCard {
      margin-left: 33rem;
      margin-right: 33rem;
    }
    @media screen and (max-width: 768px) {
      #formCard {
        margin-left: 0rem;
        margin-right: 0rem;
      }
    }
  </style>
  <!-- Import css -->
  <link rel="stylesheet" href="css/footer.css">
  <link rel="stylesheet" href="css/headerLogin.css">

  <title>Aggiungi Coltivazione</title>
  <link rel="icon" type="image/x-icon" href="img/favicon.png">

  <script src="./jquery/jquery-3.6.3.min.js"></script>
  <link href="/img/favicon.png" rel="icon">
  <link href="bootstrap-5.2.3-dist/bootstrap-icons/bootstrap-icons.css" rel="stylesheet">
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
  <link href="https://getbootstrap.com/docs/5.3/assets/css/docs.css" rel="stylesheet">
  <link href="bootstrap-5.2.3-dist/css/style.css" rel="stylesheet">
  <!-- <link href="https://getbootstrap.com/docs/5.3/assets/css/docs.css" rel="stylesheet"> -->
  <!-- link href="bootstrap-5.2.3-dist/css/style.css" rel="stylesheet"> -->
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body>
<% UtenteBean u= (UtenteBean) request.getSession().getAttribute("currentUserSession");
  if (u instanceof DipendenteBean)  { %>
<%@include file="/fragments/headerLoggedDipendente.html" %>
<%} else if(u instanceof  AziendaBean){ %>
<%@ include file="/fragments/headerLoggedAzienda.jsp" %>
<%} else { %>
<%@include file="fragments/headerLogin.html"%>
<% }%>

<%
  if (!(u instanceof AziendaBean)) {
    response.sendRedirect("error.jsp");
    return;
  }%>
<div class="bd py-2" style="width: 100%;">
  <h5 class="display-3 text-center py-5">Aggiungi una coltivazione</h5>
  <%
    /* Stampa il form per inserire la coltivazione solo se ad accedere alla pagina è un'azienda */
    if ((session.getAttribute("currentUserSession") instanceof AziendaBean)) {
      AziendaBean ab = (AziendaBean) session.getAttribute("currentUserSession");
  %> <!-- Inserisci coltivazione -->
  <div class="card py-4" id="formCard">
    <div class="card-body ">
      <% if (request.getAttribute("errore") != null) {
      %><br>
      <div id="alert" class="alert alert-warning alert-dismissible fade show" role="alert">
        <i class="bi bi-exclamation-triangle me-1"><%=request.getAttribute("descrizione")%>
        </i>
      </div>
      <%
        }
      %>
      <form action="ColtivazioniServlet" method="post" id="aggiungi_coltivazione">
        <input type="hidden" name="moduloInserimentoColtivazione" required><br>
        <label>Scegliere il terreno di cui avviare una coltivazione</label><br>
        <% //Se servletColtivazione invia un errore viene stampato un alert
          TerrenoManager tm = new TerrenoManager();
          List<TerrenoBean> tbList = tm.visualizzaListaTerreni(ab.getEmail());
          ColtivazioneManager cm = new ColtivazioneManager();
          List<ColtivazioneBean> cList = cm.visualizzaStatoColtivazioni(ab.getEmail());
          List<Integer> ids = new ArrayList<>();
          if (cList != null || cList.size() > 0) {
        %>
        <select type="text" name="terreno" required><br>
          <%
            for (int i = 0; i < cList.size(); i++) {
              ids.add(cList.get(i).getTerreno());
            }
            if (tbList != null && tbList.size() > 0) {
              for (int i = 0; i < tbList.size(); i++) {
                if (!ids.contains(tbList.get(i).getId())) {
          %>
          <option value="<%=tbList.get(i).getId()%>"> nome: <%=tbList.get(i).getNome()%>
          </option>
          <% }
          }%>
          <% } else { %>
          <label>Non ci sono terreni.</label>
          <% } %>
        </select><br>
        <% } else {
          for (int i = 0; i < ids.size(); i++) {
        %>
        <option value="<%=ids.get(i)%>">nome: <%=tm.restituisciTerrenoDaInt(ids.get(i)).getNome()%>
        </option>
        <% }
        } %>
        <label>Scegliere la pianta di cui avviare una coltivazione</label><br>
        <% cList = cm.visualizzaStatoColtivazioni(ab.getEmail());
          PiantaManager pm = new PiantaManager();
          List<PiantaBean> pList = pm.ListaPianteManager(ab.getEmail());
          if (pList == null || pList.size() == 0) {

        %>
        <h7>Non ci sono piante.</h7>
        <%
        } else {
        %>
        <select type="text" name="nomepianta" required><br>\n");
          <% for (int i = 0; i < pList.size(); i++) { %>
          <option value="<%=pList.get(i).getId()%>"><%=pList.get(i).getNome()%>
          </option>
          <% } %>
        </select><br>
        <% } %>
        <!-- INSERIMENTO DEI SENSORI -->
        <label>Scegliere i sensori da associare alla coltivazione</label><br>
        <%
          SensoreManager sm = new SensoreManager();
          List<SensoreBean> sbList = sm.visualizzaListaSensori(ab.getEmail());
          if (sbList == null || sbList.stream().filter(o -> o.getColtivazione().equals(0)).toList().size() == 0) {

        %>
        <h7>Non ci sono sensori.</h7>
        <%
        } else { %>
        <label>pH</label><br>
        <%  for (int i = 0; i < sbList.size(); i++) {
            if (sbList.get(i).getColtivazione() == 0 && sbList.get(i).getTipo().toLowerCase().equals("ph")) {
        %>
        <input type="checkbox" id="chk" name="sensorePh" value="<%=sbList.get(i).getId()%>"> Codice
        sensore: <%=sbList.get(i).getId()%><br>
        <% }
        } %>
        <label>Temperatura</label><br>
        <% for (int i = 0; i < sbList.size(); i++) {
          if (sbList.get(i).getColtivazione() == 0 && sbList.get(i).getTipo().toLowerCase().equals("temperature")) {
        %>
        <input type="checkbox" id="chk" name="sensoreTemperatura" value="<%=sbList.get(i).getId()%>"> Codice
        sensore: <%=sbList.get(i).getId()%><br>
        <% }
        } %>
        <label>Umidità</label><br>
        <%
          for (int i = 0; i < sbList.size(); i++) {
            if (sbList.get(i).getColtivazione() == 0 && (sbList.get(i).getTipo().toLowerCase().contains("umidit"))) {

        %>
        <input type="checkbox" id="chk" name="sensoreUmidita" value="<%=sbList.get(i).getId()%>"> Codice
        sensore: <%=sbList.get(i).getId()%><br>
        <%
            }
          }
          java.sql.Date todayDate = new java.sql.Date(System.currentTimeMillis());
        %>
        <label>Inserire la data di inizio della coltivazione</label><br>
        <input type="date" id="dataInizio" name="datainizio" max="" required><br><br>
        <button type="submit" id="summit" class="btn btn-primary">Aggiungi coltivazione</button>
      </form>
    </div>
  </div>
  <!-- Fine inserisci coltivazione --> </div>
<% }
}
%>
</div>
</div>
<%@include file="fragments/footer.html" %>
</body>
</html>