package com.nicico.training.service;

import com.nicico.training.TrainingException;
import com.nicico.training.dto.RequestReqVM;
import com.nicico.training.dto.RequestResVM;
import com.nicico.training.iservice.IRequestService;
import com.nicico.training.mapper.request.RequestMapper;
import com.nicico.training.model.Attachment;
import com.nicico.training.model.Request;
import com.nicico.training.model.enums.RequestStatus;
import com.nicico.training.repository.AttachmentDAO;
import com.nicico.training.repository.RequestDAO;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import response.question.dto.ElsAttachmentDto;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class RequestService implements IRequestService {

    private final RequestDAO requestDAO;
    private final RequestMapper requestMapper;
    private final AttachmentDAO attachmentDAO;
    private final ModelMapper modelMapper;

    @Override
    public List<RequestResVM> findAll() {
        List<Request> all = requestDAO.findAll();
        return requestMapper.mapListEntityToRes(all);
    }

    @Override
    public List<RequestResVM> findAllByStatus(RequestStatus status) {
        List<Request> allByStatus = requestDAO.findAllByStatus(status);
        return requestMapper.mapListEntityToRes(allByStatus);
    }

    @Override
    @Transactional
    public RequestResVM createRequest(RequestReqVM requestReqVM) {
        List<Attachment> requestAttachments=new ArrayList<>();
        Request request = requestMapper.mapReqToEntity(requestReqVM);
        Request save = requestDAO.save(request);
        if(requestReqVM.getAttachments()!=null && requestReqVM.getAttachments().size()>0){
            requestReqVM.getAttachments().forEach(elsAttachmentDto -> {
                Attachment attachment=  saveRequestAttachment(save,elsAttachmentDto);
                requestAttachments.add(attachment);
            });
            save.setRequestAttachments(requestAttachments);
        }

        return requestMapper.mapEntityToRes(save);
    }

    private Attachment saveRequestAttachment(Request request, ElsAttachmentDto elsAttachmentDto){
        Attachment create = new Attachment();
        create.setObjectId(request.getId());
        create.setObjectType("Request");
        create.setFileTypeId(5);
        create.setFileName(elsAttachmentDto.getFileName()!=null ? elsAttachmentDto.getFileName() : "noName" );
        create.setGroup_id(elsAttachmentDto.getGroupId());
        create.setKey(elsAttachmentDto.getAttachment());

      Attachment att=  attachmentDAO.saveAndFlush(create);
      return att;



    }

    @Override
    public RequestResVM changeStatus(String reference, RequestStatus status) {
        Request request = requestDAO.findByReference(reference).orElseThrow(
                () -> new TrainingException(TrainingException.ErrorType.InvalidData)
        );
        request.setStatus(status);
        Request save = requestDAO.save(request);
        return requestMapper.mapEntityToRes(save);
    }

    @Override
    public boolean remove(String reference) {
        Request request = requestDAO.findByReference(reference).orElseThrow(
                () -> new TrainingException(TrainingException.ErrorType.InvalidData)
        );
        requestDAO.delete(request);
        return true;
    }

    @Override
    public RequestResVM answerRequest(String reference, String response,RequestStatus status) {
        Request request = requestDAO.findByReference(reference).orElseThrow(
                () -> new TrainingException(TrainingException.ErrorType.InvalidData)
        );
        request.setResponse(response);
        request.setStatus(status);
        Request save = requestDAO.save(request);
        return requestMapper.mapEntityToRes(save);
    }

    @Override
    public List<RequestResVM> findAllByNationalCode(String nationalCode) {

        List<Request> allByNationalCode = requestDAO.findAllByNationalCode(nationalCode);
        if(allByNationalCode!=null && allByNationalCode.size()>0){
            allByNationalCode.stream().forEach(request -> {
                List<Attachment> requestAttachments=new ArrayList();
                List<Attachment> responseAttachments=new ArrayList<>();
              List<Attachment> reqAttachments=  attachmentDAO.findAttachmentByObjectTypeAndObjectId("Request",request.getId());
              if(reqAttachments!=null){
                  reqAttachments.stream().forEach(attachment -> {
                      requestAttachments.add(attachment);
                  });
              }
              List<Attachment> resAttachments= attachmentDAO.findAttachmentByObjectTypeAndObjectId("Response",request.getId());
              if(resAttachments!=null){
                  resAttachments.stream().forEach(attachment -> {
                      responseAttachments.add(attachment);
                  });

              }
              request.setRequestAttachments(requestAttachments);
              request.setResponseAttachments(responseAttachments);
            });
        }
     List<RequestResVM> finalList= requestMapper.mapListEntityToRes(allByNationalCode).stream().sorted(Comparator.comparing(RequestResVM::getId)).collect(Collectors.toList());
        return finalList ;

    }

    @Override
    public RequestResVM findByReference(String reference) {
        Request request = requestDAO.findByReference(reference).orElseThrow(
                () -> new TrainingException(TrainingException.ErrorType.InvalidData)
        );
        List<Attachment> requestAttachments=new ArrayList();
        List<Attachment> responseAttachments=new ArrayList<>();
        List<Attachment> reqAttachments=  attachmentDAO.findAttachmentByObjectTypeAndObjectId("Request",request.getId());
        if(reqAttachments!=null){
            reqAttachments.stream().forEach(attachment -> {
                requestAttachments.add(attachment);
            });
        }
        List<Attachment> resAttachments= attachmentDAO.findAttachmentByObjectTypeAndObjectId("Response",request.getId());
        if(resAttachments!=null){
            resAttachments.stream().forEach(attachment -> {
                responseAttachments.add(attachment);
            });

        }
        request.setRequestAttachments(requestAttachments);
        request.setResponseAttachments(responseAttachments);

        return requestMapper.mapEntityToRes(request);
    }
}
