/*
ghazanfari_f,
1/14/2020,
2:46 PM
*/
package com.nicico.training.controller;

import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.domain.criteria.NICICOCriteria;
import com.nicico.copper.common.dto.grid.TotalResponse;
import com.nicico.copper.common.dto.search.EOperator;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.controller.util.CriteriaUtil;
import com.nicico.training.dto.NeedsAssessmentDTO;
import com.nicico.training.service.NeedsAssessmentReportsService;
import com.nicico.training.service.NeedsAssessmentService;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.*;

import java.util.*;

import static com.nicico.training.service.BaseService.makeNewCriteria;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/needsAssessment")
public class NeedsAssessmentRestController {

    private final NeedsAssessmentService needsAssessmentService;
    private final ModelMapper modelMapper;
    private final NeedsAssessmentReportsService needsAssessmentReportsService;

    @Loggable
    @GetMapping("/list")
    public ResponseEntity<List<NeedsAssessmentDTO.Info>> list() {
        return new ResponseEntity<>(needsAssessmentService.list(), HttpStatus.OK);
    }

    @Loggable
    @GetMapping("/iscList")
    public ResponseEntity<TotalResponse<NeedsAssessmentDTO.Info>> iscList(@RequestParam MultiValueMap<String, String> criteria) {
        final NICICOCriteria nicicoCriteria = NICICOCriteria.of(criteria);
        return new ResponseEntity<>(needsAssessmentService.search(nicicoCriteria), HttpStatus.OK);
    }

    @Loggable
//    @Transactional(readOnly = true)
    @GetMapping("/editList/{objectType}/{objectId}")
    public ResponseEntity<SearchDTO.SearchRs<NeedsAssessmentDTO.Info>> iscList(@RequestParam MultiValueMap<String, String> criteria, @PathVariable String objectType, @PathVariable Long objectId) {
        SearchDTO.CriteriaRq criteriaRq = makeNewCriteria(null, null, EOperator.or, new ArrayList<>());
        needsAssessmentReportsService.addCriteria(criteriaRq, objectType, objectId);
        return new ResponseEntity<>(needsAssessmentService.search(new SearchDTO.SearchRq().setCriteria(criteriaRq)), HttpStatus.OK);
    }

    @Loggable
    @GetMapping("/iscList/{objectType}/{objectId}")
    public ResponseEntity<TotalResponse<NeedsAssessmentDTO.Info>> objectIdIscList(@RequestParam MultiValueMap<String, String> criteria, @PathVariable String objectType, @PathVariable Long objectId) {
        return iscList(CriteriaUtil.addCriteria(criteria, "objectId", "equals", objectId.toString()));
    }

    @Loggable
    @PostMapping
    public ResponseEntity<NeedsAssessmentDTO.Info> create(@RequestBody Object rq) {
        NeedsAssessmentDTO.Create create = modelMapper.map(rq, NeedsAssessmentDTO.Create.class);
        return new ResponseEntity<>(needsAssessmentService.checkAndCreate(create), HttpStatus.OK);
    }

    @Loggable
    @PutMapping("/{id}")
    public ResponseEntity<NeedsAssessmentDTO.Info> update(@PathVariable Long id, @RequestBody Object rq) {
        NeedsAssessmentDTO.Update update = modelMapper.map(rq, NeedsAssessmentDTO.Update.class);
        return new ResponseEntity<>(needsAssessmentService.update(id, update), HttpStatus.OK);
    }

    @Loggable
    @DeleteMapping("/{id}")
    public ResponseEntity delete(@PathVariable Long id) {
        try {
            return new ResponseEntity<>(needsAssessmentService.delete(id), HttpStatus.OK);
        } catch (Exception ex) {
            return new ResponseEntity(ex.getMessage(), HttpStatus.CONFLICT);
        }
    }

    @Loggable
    @GetMapping("/iscTree")
    public ResponseEntity<TotalResponse<NeedsAssessmentDTO.Tree>> iscTree(@RequestParam MultiValueMap<String, String> criteria) {
        final NICICOCriteria nicicoCriteria = NICICOCriteria.of(criteria);

        TotalResponse<NeedsAssessmentDTO.Tree> treeTotalResponse = (TotalResponse<NeedsAssessmentDTO.Tree>)(Object)needsAssessmentService.search(nicicoCriteria);
        treeTotalResponse.getResponse().setData(modelMapper.map(treeTotalResponse.getResponse().getData(),new TypeToken<List<NeedsAssessmentDTO.Tree>>() {}.getType()));

        List<NeedsAssessmentDTO.Tree> generations =
                findGenerations(treeTotalResponse.getResponse().getData());

        Set<NeedsAssessmentDTO.Tree> treeSet = new HashSet<NeedsAssessmentDTO.Tree>();

        int index = 1;
        for(NeedsAssessmentDTO.Tree t : treeTotalResponse.getResponse().getData()){
            index = findAncestors(treeSet,t,0,0,index);
        }

        return new ResponseEntity<>(treeTotalResponse, HttpStatus.OK);
    }

    private List<NeedsAssessmentDTO.Tree> findGenerations(List<NeedsAssessmentDTO.Tree> tree){
        Set<NeedsAssessmentDTO.Tree> ancestors = new HashSet<>();
        for(NeedsAssessmentDTO.Tree node : tree){
            /*NeedsAssessmentDTO.Tree ancestor = new NeedsAssessmentDTO.Tree();
            ancestor.setCompetenceTypeTitle(node.getCompetence().getCompetenceType().getTitle());
            ancestor.setCompetenceNameTitle(node.getCompetence().getTitle());
            ancestor.setNeedsAssessmentDomainTitle(node.getNeedsAssessmentDomain().getTitle());
            ancestor.setNeedsAssessmentPriorityTitle(node.getNeedsAssessmentPriority().getTitle());*/
            node.setCompetenceTypeTitle(node.getCompetence().getCompetenceType().getTitle());
            node.setCompetenceNameTitle(node.getCompetence().getTitle());
            node.setNeedsAssessmentDomainTitle(node.getNeedsAssessmentDomain().getTitle());
            node.setNeedsAssessmentPriorityTitle(node.getNeedsAssessmentPriority().getTitle());
            ancestors.add(node);
        }
        return new ArrayList<NeedsAssessmentDTO.Tree>(ancestors);
    }

    private int findAncestors(Set<NeedsAssessmentDTO.Tree> ancestors,NeedsAssessmentDTO.Tree child, int no, int parent, int index){
        String[] keys = {"competenceTypeTitle", "needsAssessmentDomainTitle", "needsAssessmentPriorityTitle", "competenceNameTitle"};
        int i = index;
        if(keys.length > no)
        {
            String property = keys[no];
            NeedsAssessmentDTO.Tree father = new NeedsAssessmentDTO.Tree();
            father.setProperty(property,child.getProperty(property));
            father.setParentId(new Long(parent));
            NeedsAssessmentDTO.Tree node =  ancestors.stream().filter(n -> n.equvalentOf(father,property)).findFirst().orElse(null);
            if(node == null){
//                node = new NeedsAssessmentDTO.Tree();
//                node.setProperty(property,child.getProperty(property));
//                node.setId(new Long(i));
//                node.setParentId(new Long(parent));
//                ancestors.add(node);
                father.setId(new Long(i));
                ancestors.add(father);
                parent = i;
                ++i;
            }else{
                parent = node.getId().intValue();
            }
            i = findAncestors(ancestors,child,++no,parent,i);
        }else {
            child.setParentId(new Long(parent));
            ancestors.add(child);
        }
        return i;
    }

//    private List<NeedsAssessmentDTO.Tree> findParent(List<NeedsAssessmentDTO.Tree> generation)
}
