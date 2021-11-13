//package com.nicico.training.service;
//
//import com.fasterxml.jackson.databind.JsonNode;
//import com.fasterxml.jackson.databind.ObjectMapper;
//import com.nicico.copper.common.dto.grid.TotalResponse;
//import com.nicico.copper.common.dto.search.EOperator;
//import com.nicico.copper.common.dto.search.SearchDTO;
//import com.nicico.training.TrainingException;
//import com.nicico.training.dto.*;
//import com.nicico.training.model.MessageContact;
//import com.nicico.training.model.MessageContactLog;
//import org.springframework.http.HttpStatus;
//import org.springframework.http.ResponseEntity;
//import org.springframework.web.bind.annotation.RequestBody;
//
//import java.io.IOException;
//import java.util.ArrayList;
//import java.util.Date;
//import java.util.List;
//
//import static com.nicico.training.service.BaseService.makeNewCriteria;
//
//public class test {
//
//        public ResponseEntity sendMessage( @RequestBody String data) throws IOException {
//            List<Long> ids = new ArrayList<>();
//            String type = "";
//            String link = "";
//            List<String> mobiles = new ArrayList<>();
//            List<String> fullName = new ArrayList<>();
//            List<String> prefixFullName = new ArrayList<>();
////        String personelAddress = request.getRequestURL().toString().replace(request.getServletPath(), "");
//            Long classId = null;
//            String courseName = "";
//            String courseStartDate = "";
//            String courseEndDate = "";
//            String institute = "";
//            String oMessage = "";
//            Integer maxRepeat = 0;
//            Integer timeBMessages = 0;
//            String code = null;
//            String pid = "";
//
//            TotalResponse<ParameterValueDTO.Info> parameter = null;
//
//            ObjectMapper objectMapper = new ObjectMapper();
//
//            JsonNode jsonNode = objectMapper.readTree(data);
//            oMessage = jsonNode.get("message").asText("");
//            maxRepeat = Integer.parseInt(jsonNode.get("maxRepeat").asText(""));
//            timeBMessages = Integer.parseInt(jsonNode.get("timeBMessages").asText(""));
//            link = jsonNode.get("link").asText("");
//
//            if (jsonNode.has("classID")) {
//                classId = jsonNode.get("classID").asLong();
//                TclassDTO.Info tclassDTO = tclassService.get(classId);
//                courseName = tclassDTO.getCourse().getTitleFa();
//                courseStartDate = tclassDTO.getStartDate();
//                courseEndDate = tclassDTO.getEndDate();
//                if (null!=tclassDTO.getInstitute())
//                    institute = tclassDTO.getInstitute().getTitleFa();
//                else
//                    institute = "ثبت نشده";
//            }
//
//            if (jsonNode.has("classStudent")) {
//                jsonNode = jsonNode.get("classStudent");
//                type = "classStudent";
//
//                if (jsonNode.isArray()) {
//                    for (final JsonNode objNode : jsonNode) {
//                        ids.add(objNode.asLong());
//                    }
//                }
//            } else if (jsonNode.has("classTeacher")) {
//                jsonNode = jsonNode.get("classTeacher");
//                type = "classTeacher";
//
//                if (jsonNode.isArray()) {
//                    for (final JsonNode objNode : jsonNode) {
//                        ids.add(objNode.asLong());
//                    }
//                }
//            } else if (jsonNode.has("classStudentRegistered")) {
//                jsonNode = jsonNode.get("classStudentRegistered");
//                type = "classStudentRegistered";
//
//                if (jsonNode.isArray()) {
//                    for (final JsonNode objNode : jsonNode) {
//                        ids.add(objNode.asLong());
//                    }
//                }
//            }
//
//            if (ids.size() == 0) {
//                return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
//            }
//
//
//            if (type.equals("classStudent")) {
//
//                code = "CS";
//
//                SearchDTO.SearchRq searchRq = new SearchDTO.SearchRq();
//                searchRq.setCount(1000);
//                searchRq.setStartIndex(0);
//                searchRq.setSortBy("id");
//                searchRq.setCriteria(makeNewCriteria("id", ids, EOperator.inSet, null));
//
//                SearchDTO.SearchRs<ClassStudentDTO.ClassStudentInfo> searchRs = classStudentService.search(searchRq, c -> modelMapper.map(c, ClassStudentDTO.ClassStudentInfo.class));
//
//                searchRs.getList().forEach(p -> {
//                            mobiles.add(p.getStudent().getContactInfo().getSmSMobileNumber());
//                            fullName.add(p.getFullName());
//                            prefixFullName.add(p.getStudent().getGender() == null ? "جناب آقای/سرکار خانم" : (p.getStudent().getGender().equals("مرد") ? "جناب آقای" : (p.getStudent().getGender().equals("زن") ? "سرکار خانم" : "جناب آقای/سرکار خانم")));
//                        }
//                );
//            } else if (type.equals("classTeacher")) {
//                code = "Teacher";
//
//                SearchDTO.SearchRq searchRq = new SearchDTO.SearchRq();
//                searchRq.setCount(1000);
//                searchRq.setStartIndex(0);
//                searchRq.setSortBy("id");
//                searchRq.setCriteria(makeNewCriteria("id", ids, EOperator.inSet, null));
//
//                SearchDTO.SearchRs<TeacherDTO.Info> searchRs = teacherService.search(searchRq);
//
//                searchRs.getList().forEach(p -> {
//                            mobiles.add(p.getPersonality().getContactInfo().getMobile());
//                            fullName.add(p.getFullName());
//                            prefixFullName.add(p.getPersonality().getGenderId() == null ? "جناب آقای/سرکار خانم" : (p.getPersonality().getGenderId() == 1 ? "جناب آقای" : (p.getPersonality().getGenderId() == 2 ? "سرکار خانم" : "جناب آقای/سرکار خانم")));
//                        }
//                );
//            } else if (type.equals("classStudentRegistered")) {
//
//                code = "CSR";
//
//                SearchDTO.SearchRq searchRq = new SearchDTO.SearchRq();
//                searchRq.setCount(1000);
//                searchRq.setStartIndex(0);
//                searchRq.setSortBy("id");
//                searchRq.setCriteria(makeNewCriteria("id", ids, EOperator.inSet, null));
//
//                SearchDTO.SearchRs<ClassStudentDTO.ClassStudentInfo> searchRs = classStudentService.search(searchRq, c -> modelMapper.map(c, ClassStudentDTO.ClassStudentInfo.class));
//
//                searchRs.getList().forEach(p -> {
//                            mobiles.add(p.getStudent().getContactInfo().getSmSMobileNumber());
//                            fullName.add(p.getFullName());
//                            prefixFullName.add(p.getStudent().getGender() == null ? "جناب آقای/سرکار خانم" : (p.getStudent().getGender().equals("مرد") ? "جناب آقای" : (p.getStudent().getGender().equals("زن") ? "سرکار خانم" : "جناب آقای/سرکار خانم")));
//                        }
//                );
//            }
//
//            MessageDTO.Create oMessageModel = new MessageDTO.Create();
//
//            oMessageModel.setContextText(oMessage);
//            oMessageModel.setContextHtml(oMessage);
//
//            parameter = parameterService.getByCode("MessageUserType");
//
//            String finalCode = code;
//            ParameterValueDTO.Info parameterValue = modelMapper.map(((TotalResponse) parameter).getResponse().getData().stream().filter(p -> ((ParameterValueDTO.Info) p).getCode().equals(finalCode)).toArray()[0], ParameterValueDTO.Info.class);
//
//            oMessageModel.setUserTypeId(parameterValue.getId());
//            oMessageModel.setInterval(0);
//            oMessageModel.setCountSend(0);
//            oMessageModel.setTclassId(classId);
//            oMessageModel.setMessageContactList(new ArrayList<>());
//
//            TotalResponse<ParameterValueDTO.Info> pIds = parameterService.getByCode("MessageContent");
//            String textMessage = "";
//
//            ParameterValueDTO.Info prmv;
//
//            if (type.equals("classStudent")) {
//
//                prmv = pIds.getResponse().getData().stream().filter(p -> p.getCode().equals("MCS1")).findFirst().orElseThrow(null);
//                pid = prmv.getValue();
//                textMessage = prmv.getDescription();
//
//            } else if (type.equals("classTeacher")) {
//
//                prmv = pIds.getResponse().getData().stream().filter(p -> p.getCode().equals("MTeacher2")).findFirst().orElseThrow(null);
//                pid = prmv.getValue();
//                textMessage = prmv.getDescription();
//
//            } else if (type.equals("classStudentRegistered")) {
//
//                prmv = pIds.getResponse().getData().stream().filter(p -> p.getCode().equals("MCSR")).findFirst().orElseThrow(null);
//                pid = prmv.getValue();
//                textMessage = prmv.getDescription();
//
//            }
//
//            oMessageModel.setPId(pid);
//            oMessageModel.setContextText(textMessage);
//            oMessageModel.setContextHtml(" ");
//
//            for (int i = 0; i < mobiles.size(); i++) {
//                MessageContactDTO.Create messageContact = new MessageContactDTO.Create();
//                messageContact.setObjectId(ids.get(i));
//
//                String tmpLink = "";
//
//                if (type.equals("classStudent")) {
//                    messageContact.setObjectType("ClassStudent");
//                    tmpLink = link;
//                } else if (type.equals("classTeacher")) {
//                    messageContact.setObjectType("Teacher");
//                    tmpLink = link;
//                } else if (type.equals("classStudentRegistered")) {
//                    messageContact.setObjectType("ClassStudent");
//                    tmpLink = link;
//                }
//
//                messageContact.setObjectMobile(mobiles.get(i));
//
//                List<MessageParameterDTO.Create> parameters = new ArrayList<>();
//                parameters.add(new MessageParameterDTO.Create("prefix-full_name", prefixFullName.get(i)));
//                parameters.add(new MessageParameterDTO.Create("full-name", fullName.get(i)));
//                parameters.add(new MessageParameterDTO.Create("course-name", courseName));
//
//                if (type.equals("classStudent")) {
//                    parameters.add(new MessageParameterDTO.Create("personnel-address", tmpLink));
//                } else if (type.equals("classTeacher")) {
//                    parameters.add(new MessageParameterDTO.Create("personnel-address", tmpLink));
//                } else if (type.equals("classStudentRegistered")) {
//                    parameters.add(new MessageParameterDTO.Create("personnel-address", tmpLink));
//                    parameters.add(new MessageParameterDTO.Create("institute", institute));
//                }
//
//                messageContact.setMessageParameterList(parameters);
//
//                oMessageModel.getMessageContactList().add(messageContact);
//            }
//
//            MessageDTO.Info result = messageService.create(oMessageModel);
//
//            for (int i = 0; i < mobiles.size(); i++) {
//
//                List<String> numbers = new ArrayList<>();
//                numbers.add(mobiles.get(i));
//
//                MessageContact messageContact = messageContactDAO.findById(result.getMessageContactList().get(i).getId()).orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
//
//                List<String> returnMessage = syncEnqueue(pid, convertMessageParameterToMap(oMessageModel.getMessageContactList().get(i).getMessageParameterList()), numbers);
//                Long returnMessageId = null;
//
//                MessageContactLog log = new MessageContactLog();
//
//                log.setMessageContactId(messageContact.getId());
//
//                if (returnMessage == null) {
//                    log.setErrorMessage("Error Exception");
//                    log.setReturnMessageId(null);
//                    messageContactLogDAO.save(log);
//                } else {
//                    try {
//                        returnMessageId = Long.parseLong(returnMessage.get(0));
//                        messageContact.setLastSentDate(new Date());
//                        messageContact.setCountSent(messageContact.getCountSent() + 1);
//
//                        messageContactDAO.save(messageContact);
//
//                        log.setErrorMessage("");
//                        log.setReturnMessageId(returnMessageId.toString());
//                        messageContactLogDAO.save(log);
//
//                    } catch (Exception ex) {
//                        log.setErrorMessage(ex.getMessage());
//                        log.setReturnMessageId(null);
//                        messageContactLogDAO.save(log);
//                    }
//                }
//            }
//
//            if (maxRepeat > 0) {
//
//                if (type.equals("classStudent")) {
//                    pid = pIds.getResponse().getData().stream().filter(p -> p.getCode().equals("MCS2")).findFirst().orElseThrow(null).getValue();
//                    oMessageModel.setPId(pid);
//                    oMessageModel.setContextText(pIds.getResponse().getData().stream().filter(p -> p.getCode().equals("MCS2")).findFirst().orElseThrow(null).getDescription());
//                    oMessageModel.setContextHtml(" ");
//                }
//
//                oMessageModel.setOrginalMessageId(result.getId());
//                oMessageModel.setInterval(timeBMessages);
//                oMessageModel.setCountSend(maxRepeat);
//
//                messageService.create(oMessageModel);
//            }
//
//            return new ResponseEntity<>(HttpStatus.OK);
//        }
//
//}
