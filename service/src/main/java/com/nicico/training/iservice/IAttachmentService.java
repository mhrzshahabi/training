package com.nicico.training.iservice;

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.AttachmentDTO;
import com.nicico.training.dto.question.QuestionAttachments;
import com.nicico.training.model.Attachment;
import response.BaseResponse;

import java.util.List;
import java.util.Map;

public interface IAttachmentService {
    AttachmentDTO.Info get(Long id);

//    List<AttachmentDTO.Info> list(String entityName, Long objectId);

    AttachmentDTO.Info create(AttachmentDTO.Create request);

    AttachmentDTO.Info update(Long id, AttachmentDTO.Update request);

    void delete(Long id);

    void delete(AttachmentDTO.Delete request);

    SearchDTO.SearchRs<AttachmentDTO.Info> search(SearchDTO.SearchRq request, String objectType, Long objectId);

    BaseResponse saveFmsFile(Attachment fmsUploadDto);

    QuestionAttachments getFiles(String questionBank, Long id);

    void saveSessionAttachment(Long sessionId, Map<String, String> file, String fileName);
}
