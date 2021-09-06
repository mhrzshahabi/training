package com.nicico.training.service;

import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.search.EOperator;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.AttachmentDTO;
import com.nicico.training.dto.question.QuestionAttachments;
import com.nicico.training.iservice.IAttachmentService;
import com.nicico.training.model.Attachment;
import com.nicico.training.repository.AttachmentDAO;
import lombok.RequiredArgsConstructor;
import org.hibernate.exception.ConstraintViolationException;
import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import response.BaseResponse;
import response.question.dto.ElsAttachmentDto;

import java.io.File;
import java.util.*;
import java.util.stream.Collectors;

import static com.nicico.training.service.BaseService.makeNewCriteria;

@Service
@RequiredArgsConstructor
public class AttachmentService implements IAttachmentService {

    private final ModelMapper modelMapper;
    private final AttachmentDAO attachmentDAO;
    @Value("${nicico.upload.dir}")
    private String uploadDir;
    @Value("${nicico.minioQuestionsGroup}")
    private String groupId;
    @Transactional(readOnly = true)
    @Override
    public AttachmentDTO.Info get(Long id) {
        final Optional<Attachment> gById = attachmentDAO.findById(id);
        final Attachment attachment = gById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
        return modelMapper.map(attachment, AttachmentDTO.Info.class);
    }

    @Transactional
    @Override
    public AttachmentDTO.Info create(AttachmentDTO.Create request) {
        final Attachment attachment = modelMapper.map(request, Attachment.class);
        try {
            return modelMapper.map(attachmentDAO.saveAndFlush(attachment), AttachmentDTO.Info.class);
        } catch (ConstraintViolationException | DataIntegrityViolationException e) {
            throw new TrainingException(TrainingException.ErrorType.DuplicateRecord);
        }
    }

    @Transactional
    @Override
    public AttachmentDTO.Info update(Long id, AttachmentDTO.Update request) {
        final Optional<Attachment> cById = attachmentDAO.findById(id);
        final Attachment attachment = cById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
        Attachment updating = new Attachment();
        modelMapper.map(attachment, updating);
        modelMapper.map(request, updating);
        try {
            return modelMapper.map(attachmentDAO.saveAndFlush(updating), AttachmentDTO.Info.class);
        } catch (ConstraintViolationException | DataIntegrityViolationException e) {
            throw new TrainingException(TrainingException.ErrorType.DuplicateRecord);
        }
    }

    @Transactional
    @Override
    public void delete(Long id) {
        final Optional<Attachment> one = attachmentDAO.findById(id);
        final Attachment attachment = one.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
        String fileFullPath = uploadDir + File.separator + attachment.getObjectType() + File.separator + attachment.getId();
        try {
            attachmentDAO.delete(attachment);
            File file = new File(fileFullPath);
            new File(uploadDir + File.separator + attachment.getObjectType() + File.separator + "deleted").mkdirs();
            File movedFile = new File(uploadDir + File.separator + attachment.getObjectType() + File.separator + "deleted" + File.separator + attachment.getId());
            boolean  fileRenamed=file.renameTo(movedFile);
            System.out.println("file delete :"+ fileRenamed);
        } catch (ConstraintViolationException | DataIntegrityViolationException e) {
            throw new TrainingException(TrainingException.ErrorType.NotDeletable);
        }
    }

    @Transactional
    @Override
    public void delete(AttachmentDTO.Delete request) {
        for (Long id : request.getIds()) {
            delete(id);
        }
    }

    @Transactional(readOnly = true)
    @Override
    public SearchDTO.SearchRs<AttachmentDTO.Info> search(SearchDTO.SearchRq request, String objectType, Long objectId) {
        request = (request != null) ? request : new SearchDTO.SearchRq();
        List<SearchDTO.CriteriaRq> list = new ArrayList<>();
        if (objectType != null)
            list.add(makeNewCriteria("objectType", objectType, EOperator.equals, null));
        if (objectId != null)
            list.add(makeNewCriteria("objectId", objectId, EOperator.equals, null));
        if (objectId != null || objectType != null) {
            SearchDTO.CriteriaRq criteriaRq = makeNewCriteria(null, null, EOperator.and, list);
            if (request.getCriteria() != null) {
                if (request.getCriteria().getCriteria() != null)
                    request.getCriteria().getCriteria().add(criteriaRq);
                else
                    request.getCriteria().setCriteria(list);
            } else
                request.setCriteria(criteriaRq);
        }
        return SearchUtil.search(attachmentDAO, request, attachment -> modelMapper.map(attachment, AttachmentDTO.Info.class));
    }

    @Transactional
    @Override
    public BaseResponse saveFmsFile(Attachment attachment) {
        BaseResponse response=new BaseResponse();
        try {
            attachment.setGroup_id(groupId);
            Attachment savedAttachment=attachmentDAO.save(attachment);
            if (savedAttachment.getId()!=null)
                response.setStatus(200);
            else
                response.setStatus(404);
            return response;
        } catch (ConstraintViolationException | DataIntegrityViolationException e) {
            response.setStatus(404);
            return response;
        }

    }

    @Override
    public QuestionAttachments getFiles(String questionBank, Long id) {



        List<Attachment> attachments=attachmentDAO.findAttachmentByObjectTypeAndObjectId(questionBank,id);
        if (attachments.isEmpty())
        return null;
        else
        {
            List< Map<String, String>> files=new ArrayList<>();
            List< Map<String, String>> option1Files=new ArrayList<>();
            List< Map<String, String>> option2Files=new ArrayList<>();
            List< Map<String, String>> option3Files=new ArrayList<>();
            List< Map<String, String>> option4Files=new ArrayList<>();
            QuestionAttachments questionAttachments=new QuestionAttachments();
            for (Attachment attachment:attachments)
            {
                Map<String, String> file = new HashMap<>();
                Map<String, String> option1File = new HashMap<>();
                Map<String, String> option2File = new HashMap<>();
                Map<String, String> option3File = new HashMap<>();
                Map<String, String> option4File = new HashMap<>();

                switch (attachment.getFileTypeId()){
                    case 1:
                        file.put(attachment.getKey(),attachment.getGroup_id());
                        files.add(file);
                        break;
                    case 3:
                        option1File.put(attachment.getKey(),attachment.getGroup_id());
                        option1Files.add(option1File);
                        break;
                    case 4:
                        option2File.put(attachment.getKey(),attachment.getGroup_id());
                        option2Files.add(option2File);
                        break;
                    case 5:
                        option3File.put(attachment.getKey(),attachment.getGroup_id());
                        option3Files.add(option3File);
                        break;
                    case 6:
                        option4File.put(attachment.getKey(),attachment.getGroup_id());
                        option4Files.add(option4File);
                        break;
                }
            }
            questionAttachments.setFiles(files);
            questionAttachments.setOption1Files(option1Files);
            questionAttachments.setOption2Files(option2Files);
            questionAttachments.setOption3Files(option3Files);
            questionAttachments.setOption4Files(option4Files);
            return questionAttachments;
        }
    }

    @Override
    public List<Long> getFileIds(String questionBank, Long id) {
        List<Long> ids;
        ids=attachmentDAO.findAttachmentByObjectTypeAndObjectId(questionBank,id).stream()
                .map(Attachment::getId).collect(Collectors.toList());;

        return ids;
    }

    @Transactional
    public List<Map<String, List<ElsAttachmentDto>>> getFilesToEls(String questionBank, Long id) {

        List<Attachment> attachments=attachmentDAO.findAttachmentByObjectTypeAndObjectId(questionBank,id);
        if (attachments.isEmpty())
            return null;
        else {

            List<Map<String, List<ElsAttachmentDto>>> elsFiles = new ArrayList<>();

            List<ElsAttachmentDto> elsAttachmentDtoFilesList = new ArrayList<>();
            List<ElsAttachmentDto> elsAttachmentDtoOption1List = new ArrayList<>();
            List<ElsAttachmentDto> elsAttachmentDtoOption2List = new ArrayList<>();
            List<ElsAttachmentDto> elsAttachmentDtoOption3List = new ArrayList<>();
            List<ElsAttachmentDto> elsAttachmentDtoOption4List = new ArrayList<>();

            for (Attachment attachment:attachments) {

                switch (attachment.getFileTypeId()){
                    case 1:
                        ElsAttachmentDto elsAttachmentDtoFile = new ElsAttachmentDto(attachment.getKey(), attachment.getGroup_id(), attachment.getFileName());
                        elsAttachmentDtoFilesList.add(elsAttachmentDtoFile);
                        break;
                    case 3:
                        ElsAttachmentDto elsAttachmentDtoOption1 = new ElsAttachmentDto(attachment.getKey(), attachment.getGroup_id(), attachment.getFileName());
                        elsAttachmentDtoOption1List.add(elsAttachmentDtoOption1);
                        break;
                    case 4:
                        ElsAttachmentDto elsAttachmentDtoOption2 = new ElsAttachmentDto(attachment.getKey(), attachment.getGroup_id(), attachment.getFileName());
                        elsAttachmentDtoOption2List.add(elsAttachmentDtoOption2);
                        break;
                    case 5:
                        ElsAttachmentDto elsAttachmentDtoOption3 = new ElsAttachmentDto(attachment.getKey(), attachment.getGroup_id(), attachment.getFileName());
                        elsAttachmentDtoOption3List.add(elsAttachmentDtoOption3);
                        break;
                    case 6:
                        ElsAttachmentDto elsAttachmentDtoOption4 = new ElsAttachmentDto(attachment.getKey(), attachment.getGroup_id(), attachment.getFileName());
                        elsAttachmentDtoOption4List.add(elsAttachmentDtoOption4);
                        break;
                }
            }

            Map<String, List<ElsAttachmentDto>> file = new HashMap<>();
            Map<String, List<ElsAttachmentDto>> option1 = new HashMap<>();
            Map<String, List<ElsAttachmentDto>> option2 = new HashMap<>();
            Map<String, List<ElsAttachmentDto>> option3 = new HashMap<>();
            Map<String, List<ElsAttachmentDto>> option4 = new HashMap<>();

            file.put("file", elsAttachmentDtoFilesList);
            option1.put("option1", elsAttachmentDtoOption1List);
            option2.put("option2", elsAttachmentDtoOption2List);
            option3.put("option3", elsAttachmentDtoOption3List);
            option4.put("option4", elsAttachmentDtoOption4List);

            elsFiles.add(file);
            elsFiles.add(option1);
            elsFiles.add(option2);
            elsFiles.add(option3);
            elsFiles.add(option4);

            return elsFiles;
        }
    }

    @Transactional
    @Override
    public void saveSessionAttachment(Long sessionId, Map<String, String> file, String fileName) {

        AttachmentDTO.Create createDTO = new AttachmentDTO.Create();
        createDTO.setObjectId(sessionId);
        createDTO.setObjectType("ClassSession");
        createDTO.setFileTypeId(5L);
        createDTO.setFileName(fileName);
        Optional<Map.Entry<String, String>> first = file.entrySet().stream().findFirst();
        if (first.isPresent()) {

            createDTO.setKey(first.get().getKey());
            createDTO.setGroup_id(first.get().getValue());
            try {
                Attachment attachment = modelMapper.map(createDTO, Attachment.class);
                attachmentDAO.saveAndFlush(attachment);
            } catch (ConstraintViolationException | DataIntegrityViolationException e) {
                throw new TrainingException(TrainingException.ErrorType.DuplicateRecord);
            }
        } else
            throw new TrainingException(TrainingException.ErrorType.InvalidData);
    }

}
